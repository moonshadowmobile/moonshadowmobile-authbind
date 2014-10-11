# authbind

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with authbind](#setup)
    * [What authbind affects](#what-authbind-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with authbind](#beginning-with-authbind)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
        * [Class: authbind](#class-authbind)
    * [Defined Types](#defined-types)
        * [Defined Type: authbind::port](#defined-type-authbindport)
        * [Defined Type: authbind::addr](#defined-type-authbindaddr)
        * [Defined Type: authbind::uid](#defined-type-authbinduid)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Contributors- The ones to thank or blame](#contributors)

## Overview

The authbind module installs, configures, and manages the Authbind service.

## Module Description

The authbind module is used to setup and manage access to privileged network ports using the Authbind service.  Authbind allows a program that is run as a non-privileged user to access low-numbered ports. This permission is determined for file content stored in the authbind configuration area.

There are three ways for permission to be granted:

* By port.
* By address and port.
* By user id.

This module provides defined types to utilize each of these methods.

## Setup

### What authbind affects

* The authbind package
* The files in the authbind's byport, byaddr, and byuid dirctories.

### Beginning with authbind

`include ::authbind` will set up a basic authbind system without any privleges.

## Usage

### Allowing access to a single port

The simplest way to set this up is to use the `authbind::port` defined type:

<pre>
include ::authbind

authbind::port { '445':
  user  => 'bob',
  group => 'humans',
}
</pre>

The above example will allow the user *bob* or any user in the group *humans* to run a program that listens on port 445.

### Allowing access to a range of ports

The `authbind::port` defined type also accepts ranges of ports:

<pre>
authbind::port { '912-917':
  user => 'sharron',
}
</pre>

### Restricting access to a port for a particular address

<pre>
# Listen only on the local address.
authbind::addr { '192.168.0.89':
  user  => 'calvin',
  group => 'misfits',
  port  => '67-72',
}
</pre>

### Provide multiple rules for a single user

The `authbind::uid` defined type allow you to setup multiple rules for one user.  The key deference here is that you pass a hash of the all the rules to the `ports` attribute.

<pre>
user { 'brenda':
  ensure => present,
  uid    => 78,
}

authbind::uid { '78':
  ports   => {
    89  => '192.168.0.89',
    598 => '64.123.43.90',
    876 => '0.0.0.0/24',
  }
  require => User['brenda'],
}
</pre>

## Reference

### Classes

#### Class: `authbind`

The authbind module's main class `authbind`, installs the appropriate packages.

##### `package_ensure`

Specify the state of the authbind package.

##### `package_name`

The name of the package in the system repository.

### Defined Types

#### Defined Type: `authbind::port`

Creates an appropriate file in the authbind port directory with the correct permissions.  This is the standard way to allow a user or group access to a port.

##### `user`

Required user name which authbind will allow access for.

##### `group`

Optional group name which authbind will allow access for if provided.

##### `port`

Valid TCP or UDP port or port range authbind will provide access to. Defaults to the `title`.

#### Defined Type: `authbind::addr`

##### `user`

User name which authbind will allow access for.

##### `group`

Optional group name which authbind will allow access for if provided.

##### `port`

Local TCP or UDP port or port range authbind will allow access to.

##### `addr`

Valid IPV4 or IPV6 address or address range authbind will allow access to. Defaults to the `title`.

#### Defined Type: `authbind::uid`

##### `uid`

UID of the user authbind will allow access for. Defaults to the `title`.

##### `ports`

Hash mapping each port of interest to an address or address range.

## Limitations

Authbind only has package releases on Debian and Ubuntu and has been tested on the following:

* Debian 7.x
* Ubuntu 14.04

It might be posible in the future to build authbind from the source.

## Contributors

* [Tyler Yahn](https://github.com/MrAlias)
