import java.util.UUID;

public class CoffeeShop {

	String[] userIds = new String[999999];

	int index;
	
	//회원가입 기능
	void joinMember(Guest guest) {
		//userId 발급하기
		String uuid = UUID.randomUUID().toString();
		userIds[index] = uuid;
		guest.userId = uuid;
		index++;
	}
	
}
