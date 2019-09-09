@IsTest
private class FormulaRecalculation {
	@IsTest
	static void testBehavior() {
		List<Account> testAccounts = new List<Account>();
		testAccounts.add(new Account(Name = 'One'));
		testAccounts.add(new Account(Name = 'Two'));
		insert testAccounts;

		Contact testContact = new Contact(LastName = 'Contact', AccountId = testAccounts[0].Id);
		insert testContact;

		System.assertEquals(null, testContact.AccountNameViaFormula__c, 'Should be null, formula is not evaluated yet.');

		testContact = [
				SELECT Id,
						AccountNameViaFormula__c
				FROM Contact
				WHERE Id = :testContact.Id
		];

		System.assertEquals('One', testContact.AccountNameViaFormula__c, 'Should be the name of the first account since the formula is evaluated on read.');

		// Change the associated account in memory only.
		testContact.AccountId = testAccounts[1].Id;
		List<FormulaRecalcResult> results = Formula.recalculateFormulas(new List<Contact>{
				testContact
		});
		System.assertEquals('Two', testContact.AccountNameViaFormula__c, 'Should be the name of the second account since the formula is evaluated using the Formula Class.');
		System.assertEquals('Two', results[0].getSObject().get('AccountNameViaFormula__c'), 'Should be the name of the second account since the formula is evaluated using the Formula Class.');

		//This will error out
		Account unwrittenAccount = new Account(Name = 'Three');
		testContact.Account = unwrittenAccount;

		try {
			List<FormulaRecalcResult> results2 = Formula.recalculateFormulas(new List<Contact>{
					testContact
			});
			System.assertEquals('Three', testContact.AccountNameViaFormula__c, 'Should be the name of the third account, if this works. Unfortunately, it errors out');
		} catch (Exception e) {
			System.assert(true, 'Would be nice if we were able to at least hit this line');
		}
	}
}