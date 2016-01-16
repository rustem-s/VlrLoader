using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace VlrLoader
{
    class Utils
    {
        private static string VLR_TABLE_NAME = "VLR_t";

        private static string VLR_FILE_TABLE_NAME = "VLR_FILE_t";

        private static string VLR_TEMP_TABLE_NAME = "VLR_TEMP_t";

        private static string SP_UPDATE_VLR_PARAMS = 
            "update vlr_params"
            + " set param_value = @param_value"
            + " where param_key = @param_key;";

        private static string SP_INSERT_VLR_FILE =
            "set @id_vlr_file = next value for " + VLR_FILE_TABLE_NAME + "_seq;"
            + " insert into " + VLR_FILE_TABLE_NAME + "(id, file_path, file_name, file_date)"
            + " values (@id_vlr_file, @file_path, @file_name, @file_date);";

        private static string SP_INSERT_VLR =
            "set @id_vlr = next value for vlr_seq;"
            + " insert into "+  VLR_TABLE_NAME + "(id, codreg, codarea, coddistr, imsi, msisdn, imei, accessing_time, id_vlr_file)"
            + " values (@id_vlr, @codreg, @codarea, @coddistr, @imsi, @msisdn, @imei, @accessing_time, @id_vlr_file);";

        private static string SQL_INSERT_VLR_SELECT_VLR_TEMP =
            "insert into " + VLR_TABLE_NAME + "(id, codreg, codarea, coddistr, imsi, msisdn, imei, accessing_date, accessing_time, id_vlr_file)"
            + " select"
	            + " next value for vlr_seq,"
	            + " substring(t.gcisai, 1, 5),"
	            + " substring(t.gcisai, 7, 4),"
	            + " substring(t.gcisai, 12, 4),"
	            + " t.imsi,"
	            + " t.msisdn,"
	            + " t.imei,"
	            + " convert(date, accessing_time) accessing_date,"
	            + " convert(time, accessing_time) accessing_time,"
	            + " t.id_vlr_file"
            + " from " + VLR_TEMP_TABLE_NAME + " t"
            + " where"
	            + " t.msisdn <> ''"
	            + " and t.accessing_time <> ''";

        private static string SQL_DELETE_VLR_TEMP = 
            //"delete from vlr_temp";
            "truncate table " + VLR_TEMP_TABLE_NAME;

        private static string SQL_SELECT_COUNT_VLR_FILE = 
            "select iif(count(1) = 0, 0, 1)"
		    + " from " + VLR_FILE_TABLE_NAME
		    + " where file_name = @file_name;";

        private static string SQL_SELECT_MAX_FILE_DATE_FROM_VLR_FILE =
            "select isNull(max(file_date), '01.01.1970') from " + VLR_FILE_TABLE_NAME;

        private static string SQL_SELECT_MIN_MAX_DATES_FROM_VLR_TEMP =
            " select"
                + " min(convert(datetime2, accessing_time)) min_date,"
                + " max(convert(datetime2, accessing_time)) max_date"
            + " from " + VLR_TEMP_TABLE_NAME + "t"
            + " where"
                + " t.msisdn <> ''"
                + " and t.accessing_time <> ''";


        private static string SOURCE_FILES_DATE_FORMAT = "yyyy-MM-dd HH:mm:sszzz";

        private static string VLR_TEMP_DATE_FORMAT = "dd.MM.yyyy H:mm:ss";

        /*
         * readParams
         * 
        */
        public static void readIni()
        {


            var location = new Uri(Assembly.GetEntryAssembly().GetName().CodeBase);

            string folderName = new FileInfo(location.AbsolutePath).Directory.FullName;

            IniFile ini = new IniFile(folderName + "\\VlrLoader.ini");

            // reading
            String sourceFilesPath = ini.IniReadValue("initParams", "sourceFilesPath");

            String excludeSourceFolderNames = ini.IniReadValue("initParams", "excludeSourceFolderNames");

            String excludedStringsThatStartsRows = ini.IniReadValue("initParams", "excludedStringsThatStartsRows");

            // validation
            if (String.IsNullOrEmpty(sourceFilesPath))
            {
                throw new System.Exception("Parameter 'sourceFilesPath' not exists in VlrLoader.ini");
            }

            if (String.IsNullOrEmpty(excludeSourceFolderNames))
            {
                throw new System.Exception("Parameter 'excludeSourceFolderNames' not exists in VlrLoader.ini");
            }

            if (String.IsNullOrEmpty(excludedStringsThatStartsRows))
            {
                throw new System.Exception("Parameter 'excludedStringsThatStartsRows' not exists in VlrLoader.ini");
            }

            // assign values
            Params.sourceFilesPath = sourceFilesPath;

            Params.excludeSourceFolderNames = excludeSourceFolderNames.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

            Params.excludedStringsThatStartsRows = excludedStringsThatStartsRows.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

        }

        /*
         * getFileNamesList
         * 
        */
        public static List<String> getFileNamesList(String folderPath)
        {
            List<String> fileNamesList = new List<String>();

            foreach (string f in Directory.GetFiles(folderPath))
            {
                if (!Path.GetExtension(f).Equals(".txt"))
                    continue;
                fileNamesList.Add(f);
            }
            foreach (string d in Directory.GetDirectories(folderPath))
            {

                if (!(Array.Find(Params.excludeSourceFolderNames, s => s.Equals(Path.GetFileName(d))) == null))
                    continue;

                fileNamesList.AddRange(getFileNamesList(d));
            }

            return fileNamesList;
        }

        /*
         * insertVlrFile
         * 
        */
        public static long insertVlrFile(string filePath, string fileName, DateTime fileDate)
        {

            SqlCommand query = new SqlCommand(SP_INSERT_VLR_FILE, Db.SQL_CONNECTION);

            query.Transaction = Db.SQL_TRANSACTION;
            query.CommandTimeout = 300; // seconds

            query.Parameters.AddWithValue("@file_path", filePath);
            query.Parameters.AddWithValue("@file_name", fileName);
            query.Parameters.AddWithValue("@file_date", fileDate);

            SqlParameter outPutParameter = new SqlParameter();
            outPutParameter.ParameterName = "@id_vlr_file";
            outPutParameter.SqlDbType = System.Data.SqlDbType.BigInt;
            outPutParameter.Direction = System.Data.ParameterDirection.Output;
            query.Parameters.Add(outPutParameter);

            query.ExecuteNonQuery();

            return checked((long) outPutParameter.Value);
        }

        /*
         * updateVlrParams
         * 
        */
        public static void updateVlrParams(string paramKey, string paramValue)
        {

            SqlCommand query = new SqlCommand(SP_UPDATE_VLR_PARAMS, Db.SQL_CONNECTION);

            query.Transaction = Db.SQL_TRANSACTION;
            query.CommandTimeout = 300; // seconds

            query.Parameters.AddWithValue("@param_key", paramKey);
            query.Parameters.AddWithValue("@param_value", paramValue);

            query.ExecuteNonQuery();

        }

        /*
         * execute stored proc VLRDatabase.vlr_load @date
         * 
        */
        public static void executeVlrLoad(DateTime date)
        {

            SqlCommand cmd = new SqlCommand("vlr_load", Db.SQL_CONNECTION);

            cmd.Transaction = Db.SQL_TRANSACTION;
            cmd.CommandTimeout = 43200; // seconds, 12 hours

            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add("@date", SqlDbType.Date).Value = date;

            cmd.ExecuteNonQuery();
        }


        /*
         * insertVlr
         * 
        */
        private static long insertVlr(
            SqlConnection sqlConnection, 
            SqlTransaction sqlTransaction, 
            string codreg, 
            string codarea, 
            string coddistr, 
            string imsi, 
            string msisdn, 
            string imei, 
            DateTime accessingTime, 
            long idVlrFile
        )
        {

            SqlCommand query = new SqlCommand(SP_INSERT_VLR, sqlConnection);

            query.Transaction = sqlTransaction;
            query.CommandTimeout = 300; // seconds

            query.Parameters.AddWithValue("@codreg", codreg);
            query.Parameters.AddWithValue("@codarea", codarea);
            query.Parameters.AddWithValue("@coddistr", coddistr);
            query.Parameters.AddWithValue("@imsi", imsi);
            query.Parameters.AddWithValue("@msisdn", msisdn);
            query.Parameters.AddWithValue("@imei", imei);
            query.Parameters.AddWithValue("@accessing_time", accessingTime);
            query.Parameters.AddWithValue("@id_vlr_file", idVlrFile);

            SqlParameter outPutParameter = new SqlParameter();
            outPutParameter.ParameterName = "@id_vlr";
            outPutParameter.SqlDbType = System.Data.SqlDbType.BigInt;
            outPutParameter.Direction = System.Data.ParameterDirection.Output;
            query.Parameters.Add(outPutParameter);

            query.ExecuteNonQuery();

            return checked((long)outPutParameter.Value);
        }

        /*
         * insert into VLR in loop
         * 
        */
        public static void insertVlr(SqlConnection sqlConnection, SqlTransaction sqlTransaction, string[] rows, long idVlrFile)
        {
            var dataTable = new DataTable();

            foreach (string row in rows)
            {

                // валидация строки
                if (!Utils.validateRow(row))
                    continue;

                List<string> cells = new List<String>(row.Split(new string[1] { "\t" }, StringSplitOptions.None));

                string msisdn = cells[1];
                if (String.IsNullOrEmpty(msisdn))
                    continue;

                string accessingTimeStr = cells[3];
                if (String.IsNullOrEmpty(accessingTimeStr))
                    continue;

                DateTime accessingTime = DateTime.ParseExact(accessingTimeStr.Trim(), SOURCE_FILES_DATE_FORMAT, System.Globalization.CultureInfo.InvariantCulture);

                string imsi = cells[0];
                if (imsi == null) imsi = ""; else imsi = imsi.Trim(); 

                string imei = cells[2];
                if (imei == null) imei = ""; else imei = imei.Trim(); 

                string codreg = "";
                string codearea = "";
                string coddistr = "";

                string cgisai = cells[5];
                if (String.IsNullOrEmpty(cgisai)) 
                {
                    codreg = "";
                    codearea = "";
                    coddistr = "";
                } else
                {
                    cgisai = cgisai.Trim();
                    codreg = cgisai.Substring(0, 5);
                    codearea = cgisai.Substring(6, 4);
                    coddistr = cgisai.Substring(11, 4); ;
                } 

                Utils.insertVlr(
                    sqlConnection,
                    sqlTransaction,
                    codreg,
                    codearea,
                    coddistr,
                    imsi,
                    msisdn,
                    imei,
                    accessingTime,
                    idVlrFile
                );

            }


        }

        /*
         * checkExistenceVlrFile
         * 
        */
        public static void checkExistenceVlrFile(string fileName)
        {

            SqlDataAdapter dataAdapter = new SqlDataAdapter();
            
            SqlCommand query = new SqlCommand(SQL_SELECT_COUNT_VLR_FILE, Db.SQL_CONNECTION);

            //query.Transaction = Db.SQL_TRANSACTION;
            query.CommandTimeout = 300; // seconds

            query.Parameters.AddWithValue("@file_name", fileName);

            dataAdapter.SelectCommand = query;

            DataSet dataSet = new DataSet();

            dataAdapter.Fill(dataSet, "count_vlr_file");

            DataTable dataTable = dataSet.Tables["count_vlr_file"];

            DataRow dataRow = dataTable.Rows[0];

            if (dataRow[0].ToString().Equals("1"))
            {
                throw new Exception("FILE ALREADY EXISTS IN VLR_FILE. File name: " + fileName);
            }
        }

        /*
         * checkFileDate
         * 
        */
        public static void checkFileDate(DateTime fileDate)
        {

            SqlDataAdapter dataAdapter = new SqlDataAdapter();

            SqlCommand query = new SqlCommand(SQL_SELECT_MAX_FILE_DATE_FROM_VLR_FILE, Db.SQL_CONNECTION);

            query.Transaction = Db.SQL_TRANSACTION;
            query.CommandTimeout = 300; // seconds

            dataAdapter.SelectCommand = query;

            DataSet dataSet = new DataSet();

            dataAdapter.Fill(dataSet, "max_file_date");

            DataTable dataTable = dataSet.Tables["max_file_date"];

            DataRow dataRow = dataTable.Rows[0];

            DateTime maxFileDate = (DateTime)dataRow[0];

            if (fileDate < maxFileDate)
            {
                throw new Exception(String.Format("LOADING FILES WITH DATE {0} IS PROHIBITED. FILE DATE {0} IS LESS THAN MAX FILE DATE {1} IN VLR_FILE TABLE", fileDate, maxFileDate));
            }
        }

        /*
         * updateBulkMinMaxDates
         * 
        */
        public static void updateBulkMinMaxDates()
        {

            SqlDataAdapter dataAdapter = new SqlDataAdapter();

            SqlCommand query = new SqlCommand(SQL_SELECT_MIN_MAX_DATES_FROM_VLR_TEMP, Db.SQL_CONNECTION);

            query.Transaction = Db.SQL_TRANSACTION;
            query.CommandTimeout = 300; // seconds

            dataAdapter.SelectCommand = query;

            DataSet dataSet = new DataSet();

            dataAdapter.Fill(dataSet, "dataset");

            DataTable dataTable = dataSet.Tables["dataset"];

            DataRow dataRow = dataTable.Rows[0];

            DateTime vlrTempMinDate = DateTime.ParseExact(dataRow[0].ToString().Trim(), VLR_TEMP_DATE_FORMAT, System.Globalization.CultureInfo.InvariantCulture);
            DateTime vlrTempMaxDate = DateTime.ParseExact(dataRow[1].ToString().Trim(), VLR_TEMP_DATE_FORMAT, System.Globalization.CultureInfo.InvariantCulture);

            if (vlrTempMinDate < Params.bulkMinDate)
                Params.bulkMinDate = vlrTempMinDate;

            if (vlrTempMaxDate > Params.bulkMaxDate)
                Params.bulkMaxDate = vlrTempMaxDate;
        }



        /*
         * bulkInsert
         * 
        */
        public static void bulkInsert(string[] rows, long idVlrFile)
        {
            var dataTable = new DataTable();

            for (int index = 0; index < 7; index++)
                dataTable.Columns.Add(new DataColumn());

            foreach (string row in rows)
            {

                // валидация строки
                if (!Utils.validateRow(row))
                    continue;

                DataRow dataRow = dataTable.NewRow();

                List<string> cells = new List<String>(row.Split(new string[1] { "\t" }, StringSplitOptions.None));

                cells.Add(idVlrFile.ToString());

                dataRow.ItemArray = cells.ToArray();

                dataTable.Rows.Add(dataRow);
            }

            var sqlBulkCopy = new SqlBulkCopy(Db.SQL_CONNECTION, SqlBulkCopyOptions.TableLock, Db.SQL_TRANSACTION)
            {
                DestinationTableName = VLR_TEMP_TABLE_NAME,
                BatchSize = dataTable.Rows.Count
            };

            sqlBulkCopy.WriteToServer(dataTable);
            sqlBulkCopy.Close();
        }


        /*
         * sqlDeleteVlrTemp
         * 
        */
        public static void deleteVlrTemp()
        {

            using (SqlCommand query = new SqlCommand(SQL_DELETE_VLR_TEMP))
            {
                query.Connection = Db.SQL_CONNECTION;
                query.Transaction = Db.SQL_TRANSACTION;
                query.CommandTimeout = 300; // seconds

                query.ExecuteNonQuery();
            }

        }

        /*
         * insert into VLR from select VLR_TEMP
         * 
        */
        public static void insertVlrSelectVlrTemp()
        {

            using (SqlCommand query = new SqlCommand(SQL_INSERT_VLR_SELECT_VLR_TEMP))
            {
                query.Connection = Db.SQL_CONNECTION;
                query.Transaction = Db.SQL_TRANSACTION;
                query.CommandTimeout = 300; // seconds
                query.ExecuteNonQuery();
            }

        }

        /*
         * readFileRows
         * 
        */
        public static string[] readFileRows(string fileName)
        {

            string[] rows = System.IO.File.ReadAllLines(@fileName);

            return rows;

        }

        /*
         * validateRow
         * 
        */
        public static bool validateRow(string row)
        {

            bool rowStartWithExcludedString = false;

            foreach (string excludedString in Params.excludedStringsThatStartsRows)
            {
                if (row.ToUpper().StartsWith(excludedString.ToUpper()))
                {
                    rowStartWithExcludedString = true;
                    break;
                }
            }

            return !rowStartWithExcludedString;
        }

        /*
         * parseDateFromFileName
         * 
        */
        public static DateTime parseDateFromFileName(string filePath, string fileName)
        {
            DateTime dateTime = DateTime.MinValue;

            string year;
            string month;
            string day;

            // MSS02SEV_User data_2015-9-9-23-0-2_ImmdTask10004.txt
            try
            {
                string key = "_User data_";

                int positionKey = fileName.IndexOf(key);

                int positionUnderlineAfterYear = fileName.IndexOf("-", positionKey + key.Length);

                year = fileName.Substring(positionKey + key.Length, positionUnderlineAfterYear - (positionKey + key.Length));

                int positionUnderlineAfterMonth = fileName.IndexOf("-", positionUnderlineAfterYear + 1);

                month = fileName.Substring(positionUnderlineAfterYear + 1, positionUnderlineAfterMonth - (positionUnderlineAfterYear + 1));

                int positionUnderlineAfterDay = fileName.IndexOf("-", positionUnderlineAfterMonth + 1);

                day = fileName.Substring(positionUnderlineAfterMonth + 1, positionUnderlineAfterDay - (positionUnderlineAfterMonth + 1));

                dateTime = new DateTime(Int32.Parse(year), Int32.Parse(month), Int32.Parse(day));

                return dateTime;

            }
            catch (Exception e)
            {
            }


            //Sev-2015-5-23-1.txt
            try
            {

                string key = "-";

                int positionKey = fileName.IndexOf(key);

                int positionUnderlineAfterYear = fileName.IndexOf("-", positionKey + key.Length);

                year = fileName.Substring(positionKey + key.Length, positionUnderlineAfterYear - (positionKey + key.Length));

                int positionUnderlineAfterMonth = fileName.IndexOf("-", positionUnderlineAfterYear + 1);

                month = fileName.Substring(positionUnderlineAfterYear + 1, positionUnderlineAfterMonth - (positionUnderlineAfterYear + 1));

                int positionUnderlineAfterDay = fileName.IndexOf("-", positionUnderlineAfterMonth + 1);

                day = fileName.Substring(positionUnderlineAfterMonth + 1, positionUnderlineAfterDay - (positionUnderlineAfterMonth + 1));

                dateTime = new DateTime(Int32.Parse(year), Int32.Parse(month), Int32.Parse(day));

                return dateTime;

            }
            catch (Exception e)
            {
            }


            //Sev_2015-5-24-1.txt
            try
            {

                string key = "_";

                int positionKey = fileName.IndexOf(key);

                int positionUnderlineAfterYear = fileName.IndexOf("-", positionKey + key.Length);

                year = fileName.Substring(positionKey + key.Length, positionUnderlineAfterYear - (positionKey + key.Length));

                int positionUnderlineAfterMonth = fileName.IndexOf("-", positionUnderlineAfterYear + 1);

                month = fileName.Substring(positionUnderlineAfterYear + 1, positionUnderlineAfterMonth - (positionUnderlineAfterYear + 1));

                int positionUnderlineAfterDay = fileName.IndexOf("-", positionUnderlineAfterMonth + 1);

                day = fileName.Substring(positionUnderlineAfterMonth + 1, positionUnderlineAfterDay - (positionUnderlineAfterMonth + 1));

                dateTime = new DateTime(Int32.Parse(year), Int32.Parse(month), Int32.Parse(day));

                return dateTime;

            }
            catch (Exception e)
            {
            }


            //string filepath = "\\\\smf-fs-02\\Confidential\\VLR\\copy\\MSS01SIM_User data_2015-5-13-2-40-23_ImmdTask12";
            //\\smf-fs-02\Confidential\VLR\copy\MSS01SIM_User data_2015-5-13-2-40-23_ImmdTask12   Sim1.txt
            try
            {
                string foldername = Path.GetFileName(filePath);

                Console.WriteLine("foldername = " + foldername);

                string key = "_User data_";

                int positionKey = foldername.IndexOf(key);

                int positionUnderlineAfterYear = foldername.IndexOf("-", positionKey + key.Length);

                year = foldername.Substring(positionKey + key.Length, positionUnderlineAfterYear - (positionKey + key.Length));

                int positionUnderlineAfterMonth = foldername.IndexOf("-", positionUnderlineAfterYear + 1);

                month = foldername.Substring(positionUnderlineAfterYear + 1, positionUnderlineAfterMonth - (positionUnderlineAfterYear + 1));

                int positionUnderlineAfterDay = foldername.IndexOf("-", positionUnderlineAfterMonth + 1);

                day = foldername.Substring(positionUnderlineAfterMonth + 1, positionUnderlineAfterDay - (positionUnderlineAfterMonth + 1));

                dateTime = new DateTime(Int32.Parse(year), Int32.Parse(month), Int32.Parse(day));

                return dateTime;

            }
            catch (Exception e)
            {
            }

            if (dateTime == DateTime.MinValue)

                throw new System.Exception(String.Format("Parse date from file name error: [fileName = {0}] [filePath = {1}]", fileName, filePath));

            return dateTime;

        }

    }
}