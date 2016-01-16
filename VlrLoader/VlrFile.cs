using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VlrLoader
{
    class VlrFile
    {
        private string name;
        private string path;
        private string[] rows;

        public string Name
        {
            get
            {
                return name;
            }
            set
            {
                name = value;
            }
        }

        public string Path
        {
            get
            {
                return path;
            }
            set
            {
                path = value;
            }
        }

        public string[] Rows
        {
            get
            {
                return rows;
            }
            set
            {
                rows = value;
            }
        }


    }
}
