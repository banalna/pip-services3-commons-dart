# <img src="https://github.com/pip-services/pip-services/raw/master/design/Logo.png" alt="Pip.Services Logo" style="max-width:30%"> 
# Portable Abstractions and Patterns for Dart

This framework is part of the [Pip.Services](https://github.com/pip-services/pip-services) project.
It provides portable abstractions and patterns that can be used to implement non-trivial business logic in applications and services.

This framework's key difference is its portable implementation across a variety of different languages. 
It currently supports Java, .NET, Python, Node.js, Dart, and Golang. The code provides a reasonably thin abstraction layer over most fundamental functions and delivers symmetric implementation that can be quickly ported between different platforms.

The framework's functionality is decomposed into several packages:

- **Commands** - commanding and eventing patterns
- **Config** - configuration framework
- **Convert** - soft value converters
- **Data** - data patterns
- **Errors** - application errors
- **Random** - random data generators
- **Refer** - locator (IoC) pattern
- **Reflect** - reflection framework
- **Run** - execution framework
- **Validate** - validation framework