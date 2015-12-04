using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VlrLoader
{
    class Params
    {
        public static String sourceFilesPath;
        public static String[] excludeSourceFolderNames;
        public static String[] excludedStringsThatStartsRows;

        public static DateTime bulkMinDate = DateTime.MaxValue;
        public static DateTime bulkMaxDate = DateTime.MinValue;

    }

}
