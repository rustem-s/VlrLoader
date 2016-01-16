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

                SortedDictionary<DateTime, List<VlrFile>> fileListByDate = new SortedDictionary<DateTime, List<VlrFile>>();

                // read files from folder
                List<String> fileNamesList = Utils.getFileNamesList(Params.sourceFilesPath);

                const string connectionString = "Data Source=smf-sql-01;Initial Catalog=VLRDatabase;Integrated Security=True";
                Db.SQL_CONNECTION = new SqlConnection(connectionString);
                Db.SQL_CONNECTION.Open();


                try
                {
                    // fill fileListByDate
                    foreach (string file in fileNamesList)
                    {

                        string filePath = Path.GetDirectoryName(file);

                        string fileName = Path.GetFileName(file);

                        try
                        {
                            // validate file name
                            Utils.checkExistenceVlrFile(fileName);

                            // reading file
                            string[] rows = Utils.readFileRows(file);

                            // create VlrFile instance
                            VlrFile vlrFile = new VlrFile
                            {
                                Name = fileName,
                                Path = filePath,
                                Rows = rows
                            };

                            // parse date from file name
                            DateTime fileDate = Utils.parseDateFromFileName(filePath, fileName);

                            List<VlrFile> vlrFileList;

                            if (fileListByDate.ContainsKey(fileDate))
                            {
                                vlrFileList = fileListByDate[fileDate];

                            }
                            else
                            {
                                vlrFileList = new List<VlrFile>();

                            }

                            vlrFileList.Add(vlrFile);
                            fileListByDate[fileDate] = vlrFileList;

                        }
                        catch (Exception e)
                        {
                            logger.Warn(String.Format("{0}", e.Message));
                        }

                    }


                    foreach (KeyValuePair<DateTime, List<VlrFile>> pair in fileListByDate)
                    {
                        DateTime fileDate = pair.Key;

                        logger.Info(String.Format("Inserting files of date {0}", fileDate));

                        Db.SQL_TRANSACTION = Db.SQL_CONNECTION.BeginTransaction(IsolationLevel.ReadCommitted);

                        try
                        {

                            // check file date with max file date in VLR_FILE
                            Utils.checkFileDate(fileDate);

                            // delete from VLR_TEMP
                            Utils.deleteVlrTemp();

                            foreach (VlrFile vlrFile in pair.Value)
                            {
                                try
                                {

                                    Console.WriteLine(String.Format("{0} Inserting file {1}, path {2}", DateTime.Now, vlrFile.Name, vlrFile.Path));

                                    // insert into VLR_FILE
                                    long idVlrFile = Utils.insertVlrFile(vlrFile.Path, vlrFile.Name, fileDate);

                                    // bulk insert into VLR_TEMP
                                    Utils.bulkInsert(vlrFile.Rows, idVlrFile);
                                }
                                catch (Exception e)
                                {
                                    throw new System.Exception(String.Format("ERROR ON LOAD FILE: {0}. Error message: {1}. Stacktrace: {2}", vlrFile.Name, e.Message, e.StackTrace));
                                }
                            }

                            // insert into VLR from select VLR_TEMP
                            Utils.insertVlrSelectVlrTemp();

                            Console.WriteLine(String.Format("{0} Executing database stored procedure VLR_LOAD ...", DateTime.Now));

                            // execute stored proc VLR_LOAD
                            Utils.executeVlrLoad(fileDate);

                            Db.SQL_TRANSACTION.Commit();

                            logger.Info(String.Format("Files of date {0} successfully inserted", fileDate));

                        }
                        catch (Exception e)
                        {
                            Db.SQL_TRANSACTION.Rollback();
                            logger.Error(String.Format("{0} {1}", e.Message, e.StackTrace));
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
            }
        }
    }
}
