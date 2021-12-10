using System;
using main.solutions;
using main.solutions.year2021;

namespace main {
  class MainProgram {
    private static void printUsage() {
      Console.Error.WriteLine("Usage: {0} <name>", Util.getExecutablePath());
    }
    
    public static void Main(string[] args) {
      if (args.Length < 1) {
        MainProgram.printUsage();
        Environment.Exit(0);
      }
      
      string solutionID = args[0];
      Tuple<string, string, Solution>[] solutions = {
        new Tuple<string, string, Solution>("2021_1p1", "Year 2021 Day 1 Part 1", new Day1Part1())
      };
      
      bool found = false;
      Solution sol = null;
      string readableName = null;
      foreach (Tuple<string, string, Solution> curSol in solutions) {
        if (solutionID == curSol.Item1) {
          sol = curSol.Item3;
          readableName = curSol.Item2;
          found = true;
          break;
        }
      }
      
      if (!found) {
        Console.Error.WriteLine("Unknown solution '{0}'", solutionID);
        Environment.Exit(1); 
      }
      
      sol.run();
    }
  }
}
