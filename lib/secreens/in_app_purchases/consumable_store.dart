// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// A store of consumable items.
///
/// This is a development prototype tha stores consumables in the shared
/// preferences. Do not use this in real world apps.
class ConsumableStore {
  static const String _kPrefKey = 'bronze';
  static Future<void> _writes = Future.value();

  /// Adds a consumable with ID `id` to the store.
  /// TODO: SET KEYS OF YOURS PURCHASES

  static const String _kPrefKeyFreeCourse = 'freecourse';
  static const String _kPrefKeyGolden = 'golden';
  static const String _kPrefKeyManageCapital = 'manag_capitale';
  static const String _kPrefKeyPrinciples = 'principles';
  static const String _kPrefKeyProAnalysis = 'pro_analisys';
  static const String _kPrefKeySilver = 'silver';
  static const String _kPrefKeyYourStrategy = 'your_strategy';

  /// The consumable is only added after the returned Future is complete.
  static Future<void> save(String id) {
    _writes = _writes.then((void _) => _doSave(id));
    return _writes;
  }

  /// Consumes a consumable with ID `id` from the store.
  ///
  /// The consumable was only consumed after the returned Future is complete.
  static Future<void> consume(String id) {
    _writes = _writes.then((void _) => _doConsume(id));
    return _writes;
  }

  /// TODO:: RenewableFreeCourse
// RenewableFreeCourse is only added after the returned Future is complete

  static Future<void> saveFreeCourse(String id) {
    _writes = _writes.then((void _) => _doSaveRenewableFreeCourse(id));
    return _writes;
  }

  static Future<void> FreeCourse(String id) {
    _writes = _writes.then((void _) => _doRenewableFreeCourse(id));
    return _writes;
  }

  /// TODO:: RenewableGolden
  // RenewableGolden is only added after the returned Future is complete

  static Future<void> saveGolden(String id) {
    _writes = _writes.then((void _) => _doSaveRenewableGolden(id));
    return _writes;
  }

  static Future<void> Golden(String id) {
    _writes = _writes.then((void _) => _doRenewableGolden(id));
    return _writes;
  }

  /// TODO:: RenewableManageCapital
  // RenewableManageCapital is only added after the returned Future is complete

  static Future<void> saveManageCapital(String id) {
    _writes = _writes.then((void _) => _doSaveManageCapital(id));
    return _writes;
  }

  static Future<void> ManageCapital(String id) {
    _writes = _writes.then((void _) => _doRenewableManageCapital(id));
    return _writes;
  }

  /// TODO:: RenewablePrinciples
  // RenewablePrinciples is only added after the returned Future is complete

  static Future<void> savePrinciples(String id) {
    _writes = _writes.then((void _) => _doSavePrinciples(id));
    return _writes;
  }

  static Future<void> Principles(String id) {
    _writes = _writes.then((void _) => _doRenewablePrinciples(id));
    return _writes;
  }

  /// TODO:: RenewableSliver
  // RenewableSliveris only added after the returned Future is complete

  static Future<void> saveSliver(String id) {
    _writes = _writes.then((void _) => _doSaveSliver(id));
    return _writes;
  }

  static Future<void> Sliver(String id) {
    _writes = _writes.then((void _) => _doRenewableSliver(id));
    return _writes;
  }

  /// TODO:: RenewableProAnalysis
  // RenewableProAnalysis only added after the returned Future is complete

  static Future<void> saveAnalysis(String id) {
    _writes = _writes.then((void _) => _doSaveAnalysis(id));
    return _writes;
  }

  static Future<void> ProAnalysis(String id) {
    _writes = _writes.then((void _) => _doRenewableProAnalysis(id));
    return _writes;
  }

  /// TODO:: RenewableYourStrategy
  // RenewableProAnalysis only added after the returned Future is complete

  static Future<void> saveYourStrategy(String id) {
    _writes = _writes.then((void _) => _doSaveStrategy(id));
    return _writes;
  }

  static Future<void> YourStrategy(String id) {
    _writes = _writes.then((void _) => _doRenewableYourStrategy(id));
    return _writes;
  }

  /// Returns the list of consumables from the store.
  static Future<List<String>> load() async {
    return (await SharedPreferences.getInstance()).getStringList(_kPrefKey) ??
        [];
  }

  //*********************************************************************************************

  static Future<List<String>> loadFreeCourse() async {
    return (await SharedPreferences.getInstance())
            .getStringList(_kPrefKeyFreeCourse) ??
        [];
  }

  static Future<List<String>> loadGolden() async {
    return (await SharedPreferences.getInstance())
            .getStringList(_kPrefKeyGolden) ??
        [];
  }

  static Future<List<String>> loadManageCapital() async {
    return (await SharedPreferences.getInstance())
            .getStringList(_kPrefKeyManageCapital) ??
        [];
  }

  static Future<List<String>> loadPrinciples() async {
    return (await SharedPreferences.getInstance())
            .getStringList(_kPrefKeyPrinciples) ??
        [];
  }

  static Future<List<String>> loadProAnalysis() async {
    return (await SharedPreferences.getInstance())
            .getStringList(_kPrefKeyProAnalysis) ??
        [];
  }

  static Future<List<String>> loadSilver() async {
    return (await SharedPreferences.getInstance())
            .getStringList(_kPrefKeySilver) ??
        [];
  }

  static Future<List<String>> loadYourStrategy() async {
    return (await SharedPreferences.getInstance())
            .getStringList(_kPrefKeyYourStrategy) ??
        [];
  }

  /* ***************************************************************************************** */

  static Future<void> _doSave(String id) async {
    List<String> cached = await load();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(String id) async {
    List<String> cached = await load();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKey, cached);
  }

  /* ************************************************************************************** */

  /// TODO : UPDATES FreeCourse
  static Future<void> _doSaveRenewableFreeCourse(String id) async {
    List<String> cached = await loadFreeCourse();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKeyFreeCourse, cached);
  }

  static Future<void> _doRenewableFreeCourse(String id) async {
    List<String> cached = await loadFreeCourse();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKeyFreeCourse, cached);
  }

  /// TODO : UPDATES RenewableGolden
  static Future<void> _doSaveRenewableGolden(String id) async {
    List<String> cached = await loadGolden();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKeyGolden, cached);
  }

  static Future<void> _doRenewableGolden(String id) async {
    List<String> cached = await loadGolden();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKeyGolden, cached);
  }

  /// TODO : UPDATES ManageCapital
  static Future<void> _doSaveManageCapital(String id) async {
    List<String> cached = await loadManageCapital();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKeyManageCapital, cached);
  }

  static Future<void> _doRenewableManageCapital(String id) async {
    List<String> cached = await loadManageCapital();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKeyManageCapital, cached);
  }

  /// TODO : UPDATES Principles
  static Future<void> _doSavePrinciples(String id) async {
    List<String> cached = await loadPrinciples();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKeyPrinciples, cached);
  }

  static Future<void> _doRenewablePrinciples(String id) async {
    List<String> cached = await loadPrinciples();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKeyPrinciples, cached);
  }

  /// TODO : UPDATES Sliver
  static Future<void> _doSaveSliver(String id) async {
    List<String> cached = await loadSilver();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKeySilver, cached);
  }

  static Future<void> _doRenewableSliver(String id) async {
    List<String> cached = await loadSilver();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKeySilver, cached);
  }

  /// TODO : UPDATES ProAnalysis
  static Future<void> _doSaveAnalysis(String id) async {
    List<String> cached = await loadProAnalysis();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKeyProAnalysis, cached);
  }

  static Future<void> _doRenewableProAnalysis(String id) async {
    List<String> cached = await loadProAnalysis();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKeyProAnalysis, cached);
  }

  /// TODO : UPDATES YourStrategy
  static Future<void> _doSaveStrategy(String id) async {
    List<String> cached = await loadYourStrategy();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKeyYourStrategy, cached);
  }

  static Future<void> _doRenewableYourStrategy(String id) async {
    List<String> cached = await loadYourStrategy();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKeyYourStrategy, cached);
  }
}
