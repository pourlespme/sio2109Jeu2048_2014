// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Custom HTML tags, data binding, and templates for building
/// structured, encapsulated, client-side web apps.
///
/// Polymer.dart, the next evolution of Web UI,
/// is an in-progress Dart port of the
/// [Polymer project](http://www.polymer-project.org/).
/// Polymer.dart compiles to JavaScript and runs across the modern web.
///
/// To use polymer.dart in your application,
/// first add a
/// [dependency](http://pub.dartlang.org/doc/dependencies.html)
/// to the app's pubspec.yaml file.
/// Instead of using the open-ended `any` version specifier,
/// we recommend using a range of version numbers, as in this example:
///
///     dependencies:
///       polymer: '>=0.7.1 <0.8'
///
/// Then import the library into your application:
///
///     import 'package:polymer/polymer.dart';
///
/// ## Other resources
///
/// * [Polymer.dart homepage](http://www.dartlang.org/polymer-dart/):
/// Example code, project status, and
/// information about how to get started using Polymer.dart in your apps.
///
/// * [polymer.dart package](http://pub.dartlang.org/packages/polymer):
/// More details, such as the current major release number.
///
/// * [Upgrading to Polymer.dart](http://www.dartlang.org/polymer-dart/upgrading-to-polymer-from-web-ui.html):
/// Tips for converting your apps from Web UI to Polymer.dart.
library polymer;

// Last ported from: Fri May 30 12:45:10 2014 -0700
// https://github.com/Polymer/polymer-dev/tree/32cc3e470e8ed760a9e596a24fe9b3ac2a87737c

// Note: we are still missing some tests for new features. Use
// git diff 37eea00e13b9f86ab21c85a955585e8e4237e3d2 test
// from polymer-dev to see the changes.

import 'dart:async';
import 'dart:collection';
import 'dart:html';
import 'dart:js' as js show context;
import 'dart:js' hide context;

// *** Important Note ***
// This import is automatically replaced when calling pub build by the
// mirrors_remover transformer. The transformer will remove any dependencies on
// dart:mirrors in deployed polymer apps. This and the import to
// mirror_loader.dart below should be updated in sync with changed in
// lib/src/build/mirrors_remover.dart.
//
// Technically this annotation is not needed now that we have codegen for
// expressions, but our test bots don't run pub-build yet. Until then, tests
// might (transitively) have an import to smoke.mirrors, even though the code is
// completely dead. This @MirrorsUsed annotation helps reduce the load on our
// bots.


import 'package:logging/logging.dart' show Logger, Level;
import 'package:observe/observe.dart';
import 'package:observe/src/dirty_check.dart' show dirtyCheckZone;
import 'package:polymer_expressions/polymer_expressions.dart'
    as polymer_expressions;
import 'package:smoke/smoke.dart' as smoke;
import 'package:template_binding/template_binding.dart';

import 'auto_binding.dart';
import 'deserialize.dart' as deserialize;
import 'src/static_loader.dart' as loader; // ** see important note above

export 'package:observe/observe.dart';
export 'package:observe/html.dart';
export 'auto_binding.dart';

part 'src/declaration.dart';
part 'src/events.dart';
part 'src/instance.dart';
part 'src/job.dart';
part 'src/loader.dart';
