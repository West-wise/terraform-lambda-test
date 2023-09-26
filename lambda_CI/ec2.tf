resource "aws_instance" "my_instance" {
  ami           = var.ami # 사용할 AMI ID를 지정하세요.
  instance_type = var.instance_type

  # 보안 그룹을 연결합니다.
  vpc_security_group_ids = [aws_security_group.Couque_Dasse_sg.id]

  key_name = aws_key_pair.bob_key_pair.key_name
}


#SSH Key Pair 생성
resource "aws_key_pair" "bob_key_pair" {
  key_name   = "bob_key_pair"            # SSH 키 이름
  public_key = file("~/.ssh/id_rsa.pub") # 공개 키 파일의 경로를 지정하세요.
}
