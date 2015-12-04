using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VlrLoader
{
    class Program
    {

        private static Logger logger = LogManager.GetCurrentClassLogger();

        static void Main(string[] args)
        {
            try
            {
                logger.Info("Starting the loading process");

                Utils.readIni();

                logger.Info("Source folder: " + Params.sourceFilesPath);

                // читаем файлы из папки
                List<String> fileNamesList = Utils.getFileNamesList(Params.sourceFilesPath);

                const string connectionString = "Data Source=smf-sql-01;Initial Catalog=VLRDatabase;Integrated Security=True";
                Db.SQL_CONNECTION = new SqlConnection(connectionString);
                Db.SQL_CONNECTION.Open();

                try
                {

                    foreach (string file in fileNamesList)
                    {
                        Db.SQL_TRANSACTION = Db.SQL_CONNECTION.BeginTransaction(IsolationLevel.ReadCommitted);

                        string filePath = Path.GetDirectoryName(file);

                        string fileName = Path.GetFileName(file);

                        try
                        {

                            Console.WriteLine(DateTime.Now + file);

                            // validate file name
                            Utils.checkExistenceVlrFile(fileName);

                            // parse date from file name
                            DateTime fileDate = Utils.parseDateFromFileName(filePath, fileName);

                            // insert into VLR_FILE
                            long idVlrFile = Utils.insertVlrFile(filePath, fileName, fileDate);

                            // reading file
                            string[] rows = Utils.readFileRows(file);

                            // delete from VLR_TEMP
                            Utils.deleteVlrTemp();

                            // bulk insert into VLR_TEMP
                            Utils.bulkInsert(rows, idVlrFile);

                            // update Params.bulkMinDate, Params.bulkMaxDate
                            Utils.updateBulkMinMaxDates();

                            // insert into VLR from VLR_TEMP
                            Utils.insertVlrSelectVlrTemp();

                            Console.WriteLine(DateTime.Now + " rows from " + file + " inserted successfully");

                            // update bulkMinDate, bulkMaxDate in VLR_PARAMS
                            Utils.updateVlrParams("bulkMinDate", Params.bulkMinDate.ToString("dd.MM.yyyy"));
                            Utils.updateVlrParams("bulkMaxDate", Params.bulkMaxDate.ToString("dd.MM.yyyy"));

                            Db.SQL_TRANSACTION.Commit();

                        }
                        catch (Exception e)
                        {
                            Db.SQL_TRANSACTION.Rollback();
                            logger.Error("ERROR ON LOAD FILE: " + fileName + " " + e.StackTrace + " " + e.Message);
                        }


                    }

                }
                finally
                {
                    Db.SQL_CONNECTION.Close();
                }

            }
            catch (Exception e)
            {
                logger.Error(e.StackTrace + " " + e.Message);
            }
            finally
            {

                logger.Info("Loading process is finished");
                // Keep the console window open in debug mode.
                //Console.WriteLine("Press any key to exit.");
                //System.Console.ReadKey();
            }
        }
    }
}
