// lib/pages/model/vehicle_model.dart
    class Vehicle {
      final String id;
      final String model;
      final String licensePlate;

      Vehicle({required this.id, required this.model, required this.licensePlate});

      Map<String, dynamic> toJson() => {
        'id': id,
        'model': model,
        'licensePlate': licensePlate,
      };

      factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id'],
        model: json['model'],
        licensePlate: json['licensePlate'],
      );
    }