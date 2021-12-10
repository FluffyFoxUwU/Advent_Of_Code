using System;

namespace main {
  namespace solutions {
    namespace year2021 {
      public class Day1Part1 : Solution {
        public override void run() {
          int current = -1;
          int increases = 0;
          string line = null;
          
          while ((line = Console.In.ReadLine()) != null) {
            int number = Int32.Parse(line);
            if (current != -1 && number > current) {
              increases++;
            }
            current = number;
          }
          
          Console.WriteLine(increases);
        }
      } 
    }
  }
}