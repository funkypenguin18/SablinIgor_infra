#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import argparse
from googleapiclient import discovery
from oauth2client.client import GoogleCredentials
import collections

try:
    import json
except ImportError:
    import simplejson as json

class ExampleInventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()

        # Обработка параметра `--list`.
        if self.args.list:
            self.inventory = self.example_inventory()
        # Обработка параметра `--host [hostname]`.
        elif self.args.host:
            # Не реализовано.
            self.inventory = self.empty_inventory()
        # Если нет групповых переменных, то возвращаем "пусто".
        else:
            self.inventory = self.empty_inventory()

        print json.dumps(self.inventory)

    # Анализ данных от GCE.
    def example_inventory(self):
        credentials = GoogleCredentials.get_application_default()

        service = discovery.build('compute', 'v1', credentials=credentials)

        # Код проекта.
        project = 'infra-234615'  

        # Код зоны.
        zone = 'europe-west1-b'  

        instance_dict = collections.defaultdict(dict)

        request = service.instances().list(project=project, zone=zone)
        while request is not None:
            response = request.execute()

            for instance in response['items']:
                network_tag = instance['tags']['items'][0]
                ip = instance['networkInterfaces'][0]['accessConfigs'][0]['natIP']

                instance_dict[network_tag].setdefault('hosts', []).append(ip)

            request = service.instances().list_next(previous_request=request, previous_response=response)

        return instance_dict

    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Анализ переданных параметров.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action = 'store_true')
        parser.add_argument('--host', action = 'store')
        self.args = parser.parse_args()

# Запрос списка хостов
ExampleInventory()