#!/bin/bash

docker run -it --rm -v $(pwd):/opt/dev/ --name development dockercppemacsclang:latest /bin/bash
