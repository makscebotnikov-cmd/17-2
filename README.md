# Домашнее задание к занятию "`Основы Terraform. Yandex Cloud`" - `Чеботников М.Б.`<img width="1313" height="1434" alt="1" src="https://github.com/user-attachments/assets/6a3f75a2-bdec-43f8-911f-7da9661e92c6" />


### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.12.0

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.

### Решение:

1. +
2. +
4. В файле variables.tf переменная предполагалась как "vms_ssh_root_key" заменил на "vms_ssh_public_root_key" как по заданию.
```
###ssh vars

#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "<your_ssh_ed25519_key>"
#  description = "ssh-keygen -t ed25519"
#}

# 
variable "vms_ssh_public_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519 (Public SSH key)"
}

```
5. Выполняем terraform init -> terraform plan - > terraform apply -> terraform destroy
Ошибка 1
Проблема с версией terraform, меняю
```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.12.0"
}

```

Ошибка 2
Отсутствие переменной, указал переменную ssh-keys в main.tf
```
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_public_root_key}"
  }
```

Ошибка 3
Ругался на платформу "standart-v4", такой нет, поменял на "standard-v3".

Ошибка 4
На платформе "standard-v3" значение "5" для core_fraction недоступен, устанавливаем значение "20", и значение "1" для cores недоступен, устанавливаем значение "2".

6. Подключитесь к консоли ВМ
```
yc compute instance list

eval $(ssh-agent) && ssh-add ~/.ssh/id_ed25519

ssh ubuntu@158.160.42.26

curl ifconfig.me
```

<img width="1313" height="1434" alt="1" src="https://github.com/user-attachments/assets/379e5182-c0b8-4c45-92fc-438a0430cac6" />


<img width="2438" height="275" alt="2" src="https://github.com/user-attachments/assets/a148aa81-881b-4fa1-b580-abb7c6a13b81" />


Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

preemptible = true
Прерываемая ВМ, может быть остановлена Яндексом в любой момент и время жизни не более 24 часа. Экономит деньги. Подойдет для обучения.

core_fraction = 5
Базовая производительность vCPU — 5% от физического ядра, с возможностью кратковременных бустов до 100%. Экономит деньги. Правда доступна только на плафтормах standard-v1/v2. Подойдет для фоновых задачь.

---


### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 


### Решение:

Добавляем в файл "variables.tf"
```
### VM Web variables for task 2 ###

variable "vm_web_name" {
  type        = string
  description = "VM name"
  default     = "netology-platform-web"
}

variable "vm_web_platform_id" {
  type        = string
  description = "VM platform"
  default     = "standard-v3"
}

variable "vm_web_zone" {
  type        = string
  description = "VM availability zone"
  default     = "ru-central1-a"
}

variable "vm_web_cores" {
  type        = number
  description = "Number of vCPU cores"
  default     = 2
}

variable "vm_web_memory" {
  type        = number
  description = "RAM in GB"
  default     = 1
}

variable "vm_web_core_fraction" {
  type        = number
  description = "CPU core fraction %"
  default     = 20
}

variable "vm_web_preemptible" {
  type        = bool
  description = "Preemptible VM"
  default     = true
}

variable "vm_web_nat" {
  type        = bool
  description = "Enable NAT for external IP"
  default     = true
}

variable "vm_web_serial_port_enable" {
  type        = number
  description = "Enable serial console"
  default     = 1
}

variable "vm_web_image_family" {
  type        = string
  description = "OS image family"
  default     = "ubuntu-2004-lts"
}
```

Так же вносим измепнения в main.tf, после чего запускаем -> terraform plan

Вывод: Plan: 3 to add, 0 to change, 0 to destroy.

<img width="1674" height="554" alt="3" src="https://github.com/user-attachments/assets/d6f25406-0258-420d-8a3e-4b4aad8d58da" />


---


### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

### Решение:

Обновляем три файла main.tf, variables.tf, vms_platform.tf.
Правим main.tf и variables.tf. Добавляем в файл "vms_platform.tf" переменные для VM WEB и VM DB. 
```
### VM DB variables

variable "vm_db_name" {
  type        = string
  description = "DB VM name"
  default     = "netology-platform-db"
}

variable "vm_db_platform_id" {
  type        = string
  description = "DB VM platform"
  default     = "standard-v3"
}

variable "vm_db_zone" {
  type        = string
  description = "DB VM availability zone"
  default     = "ru-central1-b"
}

variable "vm_db_cores" {
  type        = number
  description = "Number of vCPU cores for DB"
  default     = 2
}

variable "vm_db_memory" {
  type        = number
  description = "RAM in GB for DB"
  default     = 2
}

variable "vm_db_core_fraction" {
  type        = number
  description = "CPU core fraction % for DB"
  default     = 20
}

variable "vm_db_preemptible" {
  type        = bool
  description = "Preemptible DB VM"
  default     = true
}

variable "vm_db_nat" {
  type        = bool
  description = "Enable NAT for external IP for DB"
  default     = true
}

variable "vm_db_serial_port_enable" {
  type        = number
  description = "Enable serial console for DB"
  default     = 1
}

#variable "vm_db_image_family" {
#  type        = string
#  description = "OS image family for DB"
#  default     = "ubuntu-2004-lts"
#}
```

Единственное, сделал одну переменную "vm_all_image_family", так как у нас один образ для развертования.
```
### Image for VM (Ubuntu)

variable "vm_all_image_family" {
  type        = string
  description = "OS image family for all VMs"
  default     = "ubuntu-2004-lts"
}
```

<img width="2446" height="341" alt="4" src="https://github.com/user-attachments/assets/f5dd5320-60a4-48c9-a861-ea2de2a40215" />



---


### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

### Решение:

Правим outputs.tf.
```
# Output for VMs

output "vms_info" {
  description = "IP VMs"
  value = {
    web = {
      instance_name = yandex_compute_instance.platform.name
      external_ip   = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform.fqdn
    }
    db = {
      instance_name = yandex_compute_instance.platform_db.name
      external_ip   = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform_db.fqdn
    }
  }
}
```

Выполняем ```terraform output```

<img width="754" height="342" alt="5" src="https://github.com/user-attachments/assets/f343ea67-7ff1-43f8-bd12-db2658953085" />


---


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

### Решение:

Правим locals.tf.
```
locals {
  # prefix for VMs
  vm_common_prefix = "netology-platform"
  
  # VM type suffixes
  vm_web_type = "web"
  vm_db_type  = "db"
  
  # VM names full
  vm_web_name = "${local.vm_common_prefix}-${local.vm_web_type}"
  vm_db_name  = "${local.vm_common_prefix}-${local.vm_db_type}"
  
  # Zones for VM
  vm_web_zone = "ru-central1-a"
  vm_db_zone  = "ru-central1-b"
  
  # Platform for VMs
  vm_platform = "standard-v3"
  
  # Image for VMs
  vm_image_family = "ubuntu-2004-lts"
}
```

Так же вносим изменения в main.tf и vms_platform.tf.

Выполняем ```terraform output```

<img width="765" height="422" alt="6" src="https://github.com/user-attachments/assets/bfffa970-8043-4d58-afd7-49bac1f6dfc5" />


IP каждый раз будут разными, так как после каждого задания я удаляю машины.

---



### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.


### Решение:

Структура
```
src/
	providers.tf		# Провайдер
	variables.tf		# vms_resources, vms_metadata, cloud_id, folder_id, ssh_key
	locals.tf			# vm_[web\db]_name, зоны, платформа
	vms_platform.tf		# Все закомментировано
	main.tf				# Ресурсы с var.vms_resources["web\db"]
	outputs.tf			# vms_info (instance_name, external_ip, fqdn)
	terraform.tfvars	# Значения переменных
	.gitignore			# Игнорирование
```

user-test@u24-gitlab:~/netology/test-17-2/src$ cat terraform.tfvars
```
### task 6
cloud_id                = "b1gxxxxxxxxxxxxxxxxx"
folder_id               = "b1gxxxxxxxxxxxxxxxxx"
vms_ssh_public_root_key = "ssh-ed25519 AAAAC3N.......... coursework"

vms_resources = {
  web = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
  db = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

vms_metadata = {
  serial-port-enable = "1"
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3N.......... coursework"
}
```

Выполняем ```terraform plan```

<img width="840" height="1067" alt="7" src="https://github.com/user-attachments/assets/913d9cf7-741c-45ee-9142-1c99ddef1956" />



---


------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.


### Решение:

Вывод консоли:
```
local.test_list[1]

length(local.test_list)

local.test_map.admin или local.test_map["admin"]

format(
  "%s is %s for production server based on OS %s with %d vcpu, %d ram and %d virtual disks",
  local.test_map["admin"],
  local.test_map["admin"],
  local.servers["production"].image,
  local.servers["production"].cpu,
  local.servers["production"].ram,
  length(local.servers["production"].disks)
)

или 

# Промежуточные значения
admin = local.test_map["admin"]
prod = local.servers["production"]

# Форматируем
format(
  "%s is %s for production server based on OS %s with %d vcpu, %d ram and %d virtual disks",
  admin,           # имя админа
  "admin",         # роль
  prod.image,      # ОС
  prod.cpu,        # CPU
  prod.ram,        # RAM
  length(prod.disks)  # количество дисков
)

```

<img width="1159" height="438" alt="8" src="https://github.com/user-attachments/assets/a8cfbbf0-b1ce-4c16-9ca9-8a576bbcb81a" />


---


------

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.
------

------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

### Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

**Важно. Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
