[![Build Status](https://travis-ci.org/otus-devops-2019-02/SablinIgor_infra.svg?branch=ansible-3)](https://travis-ci.org/otus-devops-2019-02/SablinIgor_infra)

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

testapp_IP = 34.76.238.7
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

# Выполнено ДЗ №5

 - [x] Основное ДЗ
 - [x] Задание со *

## В процессе сделано:
 - Создан шаблон для создания image с установленными Ruby, Bundler и Mongodb (ubuntu16.json)
 - На основе шаблона ubuntu16.json запущена виртуальная машина и установлено приложение reddit-app
 - Параметризирован созданный шаблон ubuntu16.json
 - В шаблон ubuntu16.json добавлены опции билдера описание образа, размер и тип диска, название сети
 - * Создан шаблон для создания image с установленными Ruby, Bundler, Mongodb и установленным тестовым приложением (immutable.json)
 - * Подготовлен скрипт create-redditvm.sh для создания виртуальной машины при помощи gcloud

## Как проверить работоспособность:
 - Например, перейти по ссылке http://35.195.22.179:9292

# Выполнено ДЗ №6

## Ssh keys management
При управлении ssh-ключами через terraform неоходимо помнить о том, что, ключи, добавленные вручную через UI, будут удалены при выполнении очередного terraform apply.

Пример добавления нескольких ключей в проектную область

<pre>
resource "google_compute_project_metadata" "ssh_keys" {
  metadata {
    ssh-keys = "appuser5:${file(var.public_key_path)}\nappuser6:${file(var.public_key_path)}"
  }
}
</pre>

## Балансировка приложения
Добавить еще один инстанс приложения возможно через дублирование ресурса google_compute_instance. Однако, это приводит к излишнему дублированию кода и дополнительной настройки балансировщика.

Более предпочтительно использовать свойство count с указанием необходимого числа инстансов.

## Использованные источники

https://www.terraform.io/docs/providers/google/r/compute_project_metadata.html

https://stackoverflow.com/questions/49137361/how-to-use-project-wide-ssh-keys-with-terraform

https://qiita.com/sonots/items/6982b7bd9366ca7b98fd

https://cloud.google.com/load-balancing/docs/forwarding-rules

https://www.terraform.io/docs/providers/google/r/compute_health_check.html

# Выполнено ДЗ №7

## В процессе сделано:
 - Настроено правило для доступа по ssh
 - Определен ресурс для статического IP адреса
 - Создано два образа: для базы данных и тестового приложения
 - В образе для базы данных исправлена настройка конфигурации mongodb: сервис будет принимать запросы с любого IP
 - В инфрастуктуре создается две виртуальные машины (на основе образов из предыдущего пункта)
 - При создании виртуалки для тестового приложения используется функционал шаблонов для передачи IP стенда с базой данных
 - Создано три модуля: база, тестовое приложение и настройки файрвола
 - Созданы два окружения: stage и prod
 - State-файлы сохраняются в удаленных bucket-ах GCP (при этом работает блокировка состояний)

## Использованные источники

https://stackoverflow.com/questions/46618068/deploy-gcp-instance-using-terraform-and-count-with-attached-disk

https://serverfault.com/questions/737242/google-container-engine-kubernetes-1-1-1-service-loadbalancer-not-being-crea

https://www.terraform.io/docs/providers/google/r/compute_address.html

https://learn.hashicorp.com/terraform/getting-started/dependencies.html

https://www.youtube.com/watch?v=dMzY3GiJPiY

https://devopscube.com/setup-google-provider-backend-terraform/

https://serverfault.com/questions/413397/how-to-set-environment-variable-in-systemd-service

https://github.com/hashicorp/terraform/issues/14290

# Выполнено ДЗ №8

## В процессе сделано:

- Реализованы три формата статического инвентаря:
  - INI: inventory
  - YAML: inventory.yml
  - JSON: inventory.json
- Реализован плейбук для копирования из git исходного кода на сервера приложений
- Реалзиован скрипт для формирования динамического инвентори:
  - имя скрипта: gcp_inv.py
  - реализован на Python
  - используется модуль googleapiclient для получения информации с GCE
  - в качестве имени группы хостов используется network tag (допущение: он должен быть один)
  - так как используемого модуля нет на Trevis в конфигурации ансибла по-умолчанию используется статический инвентори

## Использованные источники

https://cloud.google.com/python/

https://cloud.google.com/docs/authentication/getting-started

https://cloud.google.com/compute/docs/reference/rest/v1/instances/list

https://www.jeffgeerling.com/blog/creating-custom-dynamic-inventories-ansible

https://stackoverflow.com/questions/16333296/how-do-you-create-nested-dict-in-python

https://www.oreilly.com/library/view/python-cookbook/0596001673/ch01s06.html

https://stackoverflow.com/questions/10589620/syntaxerror-non-ascii-character-xa3-in-file-when-function-returns-%C2%A3


# Выполнено ДЗ №9

## В процессе сделано:

- Работа с одним плейбуком
- Работа с несколькими плейбуками
- Использование dynamic inventory при помощи плагина ansible - gcp_compute (предпочел использовать его так как этот инструмент является для ansible целевым и не потребует скачивания дополнительных скриптов)
- При сборке packer-ом используется provisioner ansible

## Как проверить работоспособность:
 - Например, перейти по ссылке http://35.240.81.22:9292

## Использованные источники

https://michaelheap.com/ansible-importerror-no-module-named-ansible-playbook/

# Выполнено ДЗ №10 

## В процессе сделано:

- Cозданные ранее плейбуки перенесены в раздельные роли
- Описаны два окружения - prod и stage
- Использована коммьюнити роль nginx (обращение к 80-му порту)
- Использована технология Ansible Vault для создания дополнительных пользователей
- Настроены тесты Travis
  - для тестов создан внешний репозиторий https://github.com/SablinIgor/trytravis-otus-devops-work
  - реализованы тесты "packer validate"
  - реализованы тесты "terraform validate и tflint"
  - реализованы тесты "ansible-lint"
  - в файле .travis.yml при помощи matrix expansion выполнение тестов express42 и собственных выполняется параллельно
  - в файле README.md отображается бейдж с статусом билда для ветки master

## Как проверить работоспособность:
 - Например, перейти по ссылке http://104.155.70.242

## Использованные источники 

https://eng.localytics.com/best-practices-and-common-mistakes-with-travis-ci/

https://docs.travis-ci.com/user/multi-os/

https://github.com/drhelius/travis-ansible-demo/blob/master/.travis.yml

https://www.baeldung.com/travis-ci-build-pipeline

https://habr.com/ru/company/southbridge/blog/310278/
