using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace RCalc.Tests
{
	[TestClass]
	public class CalculatorTest
	{
		[TestMethod]
		public void GetClearRuneCountTest()
		{
			Assert.AreEqual(1, Calculator.GetClearRuneCount(1));
			Assert.AreEqual(2, Calculator.GetClearRuneCount(2));
			Assert.AreEqual(4, Calculator.GetClearRuneCount(3));
		}

		[TestMethod]
		public void GetCrumbCountTest()
		{
			Assert.AreEqual(Calculator.Ratios[0].Crumb, Calculator.GetCrumbCount(2, 0));
			Assert.AreEqual(Calculator.Ratios[10].Crumb, Calculator.GetCrumbCount(2, 10));

			Assert.AreEqual(64, Calculator.GetCrumbCount(4, 0));
			Assert.AreEqual(242, Calculator.GetCrumbCount(4, 14), 1);
		}

		[TestMethod]
		public void GetGoldDustCountTest()
		{
			Assert.AreEqual(Calculator.Ratios[0].GoldDust, Calculator.GetGoldRustCount(2, 0));
			Assert.AreEqual(Calculator.Ratios[10].GoldDust, Calculator.GetGoldRustCount(2, 10));

			Assert.AreEqual(8640000, Calculator.GetGoldRustCount(4, 0), 1);
			Assert.AreEqual(527, Calculator.GetGoldRustCount(4, 14), 1);
		}

		[TestMethod]
		public void GetDonateTest()
		{
			var donate = Calculator.GetDonate(1, 0);
			Assert.IsNotNull(donate);

			donate = Calculator.GetDonate(2, 0);
			Assert.AreEqual(2, donate.ClearRuneCount);

			donate = Calculator.GetDonate(3, 0);
			Assert.AreEqual(4, donate.ClearRuneCount);

			donate = Calculator.GetDonate(4, 0);
			Assert.AreEqual(8, donate.ClearRuneCount);

			donate = Calculator.GetDonate(13, 0);
			Assert.AreEqual(4096, donate.ClearRuneCount);
		}
	}
}
