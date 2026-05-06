package fruit;

public class FruitShop {
	
	void sell(Guest guest) {
		Apple apple = new Apple();
		guest.buy(apple);
		guest.taste(apple);
	}

}
