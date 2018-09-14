using System;
using System.Linq;

using System.Collections.Generic;


//using System.Text;
//using System.Threading.Tasks;

using System.Net;
using System.IO;
using System.Text.RegularExpressions;

namespace stockfilter
{
    class Program
    {
        static void Main(string[] args)
        {
            //var url = "http://app.finance.china.com.cn/stock/operate/stock.php?code=sh600183";
            var url0 = "http://app.finance.china.com.cn/stock/operate/stock.php?code=";

            var stocks = Stocks();
            var outs = new Dictionary<double, string>();

            foreach (var s in stocks)
            {
                if (s.Key.Substring(0, 1) == "6")
                {
                    var txt = CellsFilter(RowsFilter(TableFilter(GetHtml(url0 + "sh" + s.Key))));
                    //Console.WriteLine(s.Key + s.Value + " ### " + Filter001(txt)[0] + "###" + Filter001(txt)[1]);
                    outs.Add(Filter001(txt)[0] + Filter001(txt)[1], s.Key + s.Value + " ### " + Filter001(txt)[0] + "###" + Filter001(txt)[1]);
                }

                if (s.Key.Substring(0, 1) == "0")
                {
                    var txt = CellsFilter(RowsFilter(TableFilter(GetHtml(url0 + "sz" + s.Key))));
                    //Console.WriteLine(s.Key + s.Value + " ### " + Filter001(txt)[0] + "###" + Filter001(txt)[1]);
                    outs.Add(Filter001(txt)[0] + Filter001(txt)[1], s.Key + s.Value + " ### " + Filter001(txt)[0] + "###" + Filter001(txt)[1]);
                    
                }

            }

            var l = outs.Keys.ToList();
            l.Sort();

            foreach (var k in l) 
            {
                Console.WriteLine(outs[k]);
            }
            
            Console.ReadKey();

        }


        static string GetHtml(string url)
        {
            String html;
            WebResponse response;
            WebRequest request = HttpWebRequest.Create(url);
            response = request.GetResponse();

            using (StreamReader rdr = new StreamReader(response.GetResponseStream()))
            {
                html = rdr.ReadToEnd();
                rdr.Close();
            }

            return html;
        }



        static string TableFilter(string html)
        {

            string result;

            //string tt = @"<table[^]+<\/table>";
            string tt = @"<table(?:\r|\n|.)+<\/table>";

            var matches = Regex.Matches(html, tt, RegexOptions.Multiline | RegexOptions.Singleline | RegexOptions.IgnoreCase);
            result = matches[0].Value;


            return result;

        }

        static List<string> RowsFilter(string html)
        {

            List<string> result;

            var rowstemp = @"<tr>(?:\r|\n|.)*?<\/tr>";

            var matches = Regex.Matches(html, rowstemp, RegexOptions.Multiline | RegexOptions.Singleline | RegexOptions.IgnoreCase);

            result = (from Match m in matches select m.Value).ToList();

            return result;

        }

        static List<object> CellsFilter(List<string> rows)
        {
            var colnames = new string[4] { "date", "price", "change", "volume" };
            var cols = new int[4] { 0, 1, 2, 4 };

            var price = new List<decimal>();
            var change = new List<decimal>();
            var volume = new List<int>();
            var date = new List<DateTime>();


            string celltemp = @"<td(?:.*?)>(.*?)<\/td>";

            var dectemp = @"-?\d+\.\d{2}";
            var inttemp = @"\d+";
            var datetemp = @"\d{4}-\d{2}-\d{2}";

            int i = 0;
            foreach (var r in rows)
            {
                if (i++ > 0) // header 
                {
                    var matches = Regex.Matches(r, celltemp, RegexOptions.Multiline | RegexOptions.Singleline | RegexOptions.IgnoreCase);
                    var cells = (from Match m in matches select m.Value).ToList();

                    //price.Add(Convert.ToDecimal(cells[cols[Array.IndexOf(colnames, "price")]]));
                    price.Add(Convert.ToDecimal(Regex.Match(cells[cols[Array.IndexOf(colnames, "price")]], dectemp).Value));


                    change.Add(Convert.ToDecimal(Regex.Match(cells[cols[Array.IndexOf(colnames, "change")]], dectemp).Value));
                    volume.Add(Convert.ToInt32(Regex.Match(cells[cols[Array.IndexOf(colnames, "volume")]], inttemp).Value));
                    date.Add(DateTime.Parse(Regex.Match(cells[cols[Array.IndexOf(colnames, "date")]], datetemp).Value));
                }

                //i++;
            }

            var result = new List<object>() { date, price, change, volume };
            return result;

        }

        static List<double> Filter001(List<object> d)
        {
            var price0 = (List<decimal>)d[1];
            var change0 = (List<decimal>)d[2];
            var volume0 = (List<int>)d[3];
            var date0 = (List<DateTime>)d[0];
            

            var n = 5;
            // last three days price up and volume up
            var volume = new List<decimal>();
            var price = new List<decimal>();
            for (int i = 0; i < n; i++)
            {
                volume.Add(volume0[i]);
                price.Add(price0[i]);
            }
           

            //scaling
            var priceMax = price.Max();
            var priceMin = price.Min();
            var volMax = volume.Max();
            var volMin = volume.Min();
            var xx = new decimal[5] { 5, 4, 3, 2, 1 };
            var xxMax = xx.Max();
            var xxMin = xx.Min();
            for (int i = 0; i < n; i++)
            {
                price[i] = (price[i] - priceMin) / (priceMax - priceMin);
                volume[i] = (decimal)(volume[i] - volMin) / (decimal)(volMax - volMin);
                xx[i] = (xx[i] - xxMin) / (xxMax - xxMin);
            }
          

            double xy0 = 0, x0 = 0, y0 = 0, x20 = 0, y20 = 0;
            for (int i = 0; i < n; i++)
            {
                x0 += (double)volume[i];
                y0 += (double)price[i];
                xy0 += (double)volume[i] * (double)price[i];
                x20 += (double)volume[i] * (double)volume[i];
                y20 += (double)price[i] * (double)price[i];

            }

            // correlation
            double r = (n * xy0 - x0 * y0) / Math.Sqrt((n * x20 - x0 * x0) * (n * y20 - y0 * y0));

            //trend
            double xxyy0 = 0, xx0 = 0, yy0 = 0, xx20 = 0, yy20 = 0;
            //var xx = new int[5]{5,4,3,2,1};
            for (int i = 0; i < n; i++)
            {
                xx0 += (double)xx[i];
                yy0 += (double)price[i];
                xxyy0 += (double)xx[i] * (double)price[i];
                xx20 += (double)xx[i] * (double)xx[i];
                yy20 += (double)price[i] * (double)price[i];

            }
            double b = (n * xxyy0 - xx0 * yy0) / (n * xx20 - xx0 * xx0);

            var result = new List<double>() { r, b };
            return result;
        }

        static Dictionary<string, string> Stocks()
        {
            var s = new Dictionary<string, string>()
            {
                {"002569","步森股份"},
                {"600976","健民集团"},
                {"600592","龙溪股份"},
                {"600401","海润光伏"},
                {"603238","诺邦股份"},
                {"600847","万里股份"},
                {"600538","国发股份"},
                {"002612","朗姿股份"},
                {"002572","索菲亚"},
                {"000880",	"潍柴重机"},
                {"002085","万丰奥威"},
                {"300534","陇神戎发"},
                {"002620","瑞和股份"},
                {"002188","巴士在线"},
                {"000408","*ST金源"},
                {"002201","九鼎新材"},
                {"002301","齐心集团"},
                {"002689","远大智能"},
                {"000710","*ST天仪"},
                {"002280","联络互动"},
                {"601238","广汽集团"},
                {"002102","冠福股份"},
                {"603703","盛洋科技"},
                {"002607","亚夏汽车"},
                {"002719","麦趣尔"},
                {"002435","长江润发"},
                {"600367","红星发展"},
                {"000885","同力水泥"},
                {"002305","南国置业"},
                {"300354","东华测试"},
                {"300599","雄塑科技"},
                {"600777","新潮能源"},

                {"600893","中航动力"}, 
                {"600705","中航资本"},
                {"002013","中航机电"},
                {"600765","中航重机"},
                {"600038","中直股份"},
                {"002179","中航光电"},
                {"300264","佳创视讯"},
                {"300286","安科瑞"},
                {"000547","航天发展"},
                {"300620","光库科技"}, 
                {"000969","安泰科技"},
                {"600469","风神股份"}, 
                {"600677","航天通信"},
                {"000901","航天科技"},
                {"600501","航天晨光"}, 
                {"601288","农业银行"},
                {"300015","爱尔眼科"},
                {"601111","中国国航"},
                {"300458","全志科技"},
                {"002231","奥维通信"}

            };

            return s;
        }
    }
}
