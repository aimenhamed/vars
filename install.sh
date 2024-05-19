#!/bin/bash

gleam run -m gleescript
chmod +x ./vars
sudo cp ./vars /usr/local/bin
