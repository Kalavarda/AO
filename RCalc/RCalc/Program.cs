using System;

namespace RCalc
{
	internal class Program
	{
		private static void Main()
		{
			while (true)
			{
				Console.Write("Какого уровня скрафтить? ");
				var level = int.Parse(Console.ReadLine());
				Calc(level);
			}
		}

		private static void Calc(int level)
		{
			var min = decimal.MaxValue;
			var minIndex = -1;
			for (var i = 0; i < Calculator.Ratios.Length; i++)
			{
				var cry = Calculator.ToCry(Calculator.GetDonate(level, i));
				if (cry < min)
				{
					minIndex = i;
					min = cry;
				}
			}

			var donate = Calculator.GetDonate(level, minIndex);
			var cost = (int) Calculator.ToCry(donate);

			var goldAtDust = Calculator.GoldDustCost * donate.GoldDustCount;

			//Console.WriteLine("Чтобы скрафтить руну уровня " + level);
			Console.WriteLine();

			minIndex -= Calculator.Ratios.Length / 2;
			Console.WriteLine($"shift: {minIndex}");
			Console.WriteLine($"Cost: {cost:### ### ### ###} руб");
			Console.WriteLine();

			Console.WriteLine($"Чистых рун: {donate.ClearRuneCount:### ### ### ### ###}");
			Console.WriteLine($"Крошки: {donate.CrystalCrumbCount:### ### ### ### ###}");
			Console.WriteLine($"Пыли: {donate.GoldDustCount:### ### ### ### ### ###} (золота {goldAtDust:### ### ### ### ### ###})");

			Console.WriteLine();
			Console.WriteLine("*******************************************************************");
			Console.WriteLine();
		}
	}
}
