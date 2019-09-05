/**
 * Created by triestelaporte on 8/29/19.
 */

@IsTest
private class AlsoCouldHaveBeenADirtyWord {
	@IsTest
	static void testBehavior () {
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
		Formula.recalculateFormulas(new List<Contact>{
				testContact
		});
		System.assertEquals('Two', testContact.AccountNameViaFormula__c, 'Should be the name of the second account since the formula is evaluated using the Formula Class.');

		//This will error out
		Account unwrittenAccount = new Account(Name = 'Three');
		testContact.Account = unwrittenAccount;

		Formula.recalculateFormulas(new List<Contact>{
				testContact
		});
		System.assertEquals('Three', testContact.AccountNameViaFormula__c, 'Should be the name of the third account, if this works. Unfortunately, it errors out');
	}
}