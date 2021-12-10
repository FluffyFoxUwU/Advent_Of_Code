using System.Reflection;
using System.IO;

namespace main {
  class Util {
    public static string getExecutablePath() {
      return Path.GetFileName(Assembly.GetExecutingAssembly().Location);
    }
  }
}