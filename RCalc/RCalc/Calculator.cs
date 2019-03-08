using System;

namespace RCalc
{
	public static class Calculator
	{
		public const decimal GoldDustCost = 8500.0m / 1000000m;		// стоимость 1 млн пыли
		public const decimal ClearRuneCost = 0.4512m;						// стоимость чистой руны 1-й ступени
		public const decimal CrystalCrumbCost = 1m / 13m;				// стоимость крошки в кристаллах
		public const decimal CrystalToGold = 10720.0m;					// цена золота
		private const int MaxLevel = 13;

		// 1 - 2
		public static readonly Ratio[] Ratios = new[]
		{
			new Ratio { GoldDust = 3840000, Crumb = 28 },
			new Ratio { GoldDust = 1920000, Crumb = 31 },
			new Ratio { GoldDust = 960000, Crumb = 34 },
			new Ratio { GoldDust = 480000, Crumb = 38 },
			new Ratio { GoldDust = 240000, Crumb = 41 },
			new Ratio { GoldDust = 120000, Crumb = 45 },
			new Ratio { GoldDust = 60000, Crumb = 50 },
			new Ratio { GoldDust = 30000, Crumb = 55 },
			new Ratio { GoldDust = 15000, Crumb = 61 },
			new Ratio { GoldDust = 7500, Crumb = 67 },
			new Ratio { GoldDust = 3750, Crumb = 73 },
			new Ratio { GoldDust = 1875, Crumb = 81 },
			new Ratio { GoldDust = 938, Crumb = 89 },
			new Ratio { GoldDust = 469, Crumb = 97 },
			new Ratio { GoldDust = 234, Crumb = 107 },
		};

		// 11 - 12
		public static readonly Ratio[] Ratios2 = new[]
		{
			new Ratio { GoldDust = 442867456, Crumb = 3256 },
			new Ratio { GoldDust = 221433728, Crumb = 3582 },
			new Ratio { GoldDust = 110716864, Crumb = 3940 },
			new Ratio { GoldDust = 55358432, Crumb = 4334 },
			new Ratio { GoldDust = 27679216, Crumb = 4766 },
			new Ratio { GoldDust = 13839608, Crumb = 5242 },
			new Ratio { GoldDust = 6919804, Crumb = 5768 },
			new Ratio { GoldDust = 3459902, Crumb = 6344 },
			new Ratio { GoldDust = 1729952, Crumb = 6978 },
			new Ratio { GoldDust = 864976, Crumb = 7676 },
			new Ratio { GoldDust = 432488, Crumb = 8444 },
			new Ratio { GoldDust = 216244, Crumb = 9288 },
			new Ratio { GoldDust = 108122, Crumb = 10218 },
			new Ratio { GoldDust = 54060, Crumb = 11238 },
			new Ratio { GoldDust = 27030, Crumb = 12362 },
		};

		public static int GetClearRuneCount(int level)
		{
			if (level < 1 || level > MaxLevel)
				throw new ArgumentException();
			
			if (level == 1)
				return 1;

			return 2 * GetClearRuneCount(level - 1);
		}

		public static Donate GetDonate(int level, int ratioNumber)
		{
			if (level < 1 || level > MaxLevel)
				throw new ArgumentException();

			if (ratioNumber < 0 || ratioNumber > Ratios2.Length - 1)
				throw new ArgumentException();

			if (level == 1)
				return new Donate
				{
					ClearRuneCount = GetClearRuneCount(1),
					CrystalCrumbCount = 0,
					GoldDustCount = 0,
				};

			var prev = GetDonate(level - 1, ratioNumber);
			prev.ClearRuneCount *= 2;
			prev.GoldDustCount *= 2;
			prev.CrystalCrumbCount *= 2;

			return new Donate
			{
				ClearRuneCount = prev.ClearRuneCount,
				CrystalCrumbCount = GetCrumbCount(level, ratioNumber) + prev.CrystalCrumbCount,
				GoldDustCount = GetGoldRustCount(level, ratioNumber) + prev.GoldDustCount
			};
		}

		public static int GetCrumbCount(int toLevel, int ratioNumber)
		{
			if (toLevel <= 1 || toLevel > MaxLevel)
				throw new ArgumentException();

			var result = (decimal)Ratios2[ratioNumber].Crumb / 2;	// 12
			for (var i = 0; i < 10; i++)
				result /= 1.5m;

			for (var i = 2; i < toLevel; i++)
				result *= 1.5m;

			return (int)Math.Round(result);
		}

		public static int GetGoldRustCount(int toLevel, int ratioNumber)
		{
			if (toLevel <= 1 || toLevel > MaxLevel)
				throw new ArgumentException();

			var result = (decimal)Ratios2[ratioNumber].GoldDust / 2;	// 12
			for (var i = 0; i < 10; i++)
				result /= 1.5m;

			for (var i = 2; i < toLevel; i++)
				result *= 1.5m;

			return (int)Math.Round(result);
		}

		public static decimal ToCry(Donate donate)
		{
			if (donate == null) throw new ArgumentNullException("donate");

			var gold = donate.ClearRuneCount * ClearRuneCost + donate.GoldDustCount * GoldDustCost;

			return
				donate.CrystalCrumbCount * CrystalCrumbCost + gold / CrystalToGold;
		}

		public class Ratio
		{
			public int GoldDust { get; set; }

			public int Crumb { get; set; }
		}

		public class Donate
		{
			public long ClearRuneCount { get; set; }

			public long GoldDustCount { get; set; }

			public long CrystalCrumbCount { get; set; }
		}
	}
}
