#!/bin/bash

PATH="${PATH}:/vagrant/imposm3/bin"
        
make link
make db/toronto
make db/italy
make db/ontario
make db/OH
make db/shared


