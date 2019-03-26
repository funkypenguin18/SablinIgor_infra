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

## Homework IV. Деплой тестового приложения.

testapp_IP = 35.195.22.179
testapp_port = 9292

Запуск VM с установочным скриптом

<pre>
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=startup-script.sh
  </pre>

Настройка firewall rule через gcloud

<pre>
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 \
      --description "Allow incoming traffic on TCP port 9292 (puma server)" \
      --source-ranges="0.0.0.0/0" \
      --target-tags=«puma-server»
      --direction INGRESS
</pre>