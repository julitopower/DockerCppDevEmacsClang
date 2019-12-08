# Usage

Pull the image from
[DockerHub](https://hub.docker.com/r/julitopower/dockercppdevemacsclang).

# Included software

* Clang-6.0.1
* Eigen-3.90
* Emacs-26.3 (includes irony-mode for C++ code completion)
* Gcc-7.4.0 (C++11, C++14, C++17)
* PocoLib-1.9.4
* Python-2.7.15+
* Python-3.6.8
* Rapidjson-1.1.0

# Build

Build the image by executing

```
$ docker build -t dockercppemacsclang:latest .
```

# Run

```
$ docker run -it --rm -v ~:/opt/src dockercppemacsclang:latest
```
