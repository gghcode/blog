This is repository contained blog contents. You can visit blog at gghcode.github.io

# Basic Usage

## 1. Clone blog repository

```sh
$ git clone --recursive git@github.com:gghcode/blog.git
```

or

```sh
$ git clone git@github.com:gghcode/blog.git
$ git submodule init
$ git submodule update
```

## 2. Build hugo site

```sh
$ make build
```

## 3. Run hugo-server on local

```sh
$ make run
```

## 4. Create new blog post

```sh
$ make post title="<title>"
```
