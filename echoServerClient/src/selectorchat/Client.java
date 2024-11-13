package selectorchat;

//닉네임을 가지는 클라이언트
class Client {
	// 아직 닉네임 입력이 안된 경우 true
	private boolean isNickCheck = true;
	private String nick;

	// 닉네임이 들어있는지 확인
	boolean isNick() {
		return isNickCheck;
	}

	// 닉네임을 입력받으면 false로 변경
	void setCheck() {
		isNickCheck = false;
	}

	// NickName 정보 반환
	String getNick() {
		return nick;
	}

	// NickName 입력
	void setNick(String nick) {
		this.nick = nick;
		setCheck();
	}
}

