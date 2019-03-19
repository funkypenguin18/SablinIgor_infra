# SablinIgor_infra

Подключения к someinternalhost в одну команду: ssh -At -i ~/.ssh/ubuntu -A ubuntu@35.233.72.169 ssh 10.132.0.3

Вариант решения для подключения из консоли при помощи команды вида ssh someinternalhost из локальной консоли рабочего устройства, чтобы подключение выполнялось по алиасу someinternalhost:

Внести в ~/.ssh/config следующие настройки:

<pre>
Host bastion
    HostName 04.155.5.163
    User ubuntu

Host someinternalhost 10.132.0.30
    User ubuntu
    ProxyCommand ssh -i ~/.ssh/ubuntu -A bastion nc -w 180 %h %p% 
</pre>

bastion_IP = 104.155.5.163

someinternalhost_IP = 10.132.0.30

