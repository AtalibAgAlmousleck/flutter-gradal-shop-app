import 'package:flutter/material.dart';

import 'employee.dart';

class EmployeeProvider extends ChangeNotifier {
  final List<Employee> _employees = [];
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  List<Employee> get employees => _employees;
  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;

  void addEmployee(Employee employee) {
    _employees.add(employee);
    notifyListeners();
  }

  void updateEmployee(int index, Employee employee) {
    _employees[index] = employee;
    notifyListeners();
  }

  void deleteEmployee(int index) {
    _employees.removeAt(index);
    notifyListeners();
  }

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  List<Employee> get paginatedEmployees {
    int start = _currentPage * _rowsPerPage;
    int end = start + _rowsPerPage;
    return _employees.sublist(start, end > _employees.length ? _employees.length : end);
  }
}
