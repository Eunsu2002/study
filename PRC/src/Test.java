
public class Test {

	public static void main(String[] args) {
		
		CoffeeShop coffeeShop = new CoffeeShop();

		for (int i = 0 ; i < 1001 ; i++) {
			Guest guest = new Guest();
			coffeeShop.joinMember(guest);
		}
		
		System.out.println();
	}
	
}
