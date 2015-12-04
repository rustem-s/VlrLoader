using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VlrLoader
{
    class Db
    {
        public static SqlConnection SQL_CONNECTION;
        public static SqlTransaction SQL_TRANSACTION;
    }
}
