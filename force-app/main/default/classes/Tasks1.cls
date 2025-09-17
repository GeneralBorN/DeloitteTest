public with sharing class Tasks1 {
    public interface IVehicle {
        // TODO: Add method signature for startEngine() that returns String
        String startEngine();
        // TODO: Add method signature for getMaxSpeed() that returns Integer
        Integer getMaxSpeed();
    }

    public abstract class VehicleDesign {
        public String brand;
        public String model;
        public String fuelType;
        
        public VehicleDesign(String vehicleBrand, String vehicleModel, String fuel) {
            this.brand = vehicleBrand;
            this.model = vehicleModel;
            this.fuelType = fuel;
        }
        
        // Abstract method signature for getMaintenance() that returns String
        public abstract String getMaintenance();
        
        // Concrete method all vehicles can use
        public void displayInfo() {
            System.debug('Vehicle: ' + brand + ' ' + model + ' (Fuel: ' + fuelType + ')');
        }
    }


    public virtual class BasicTransport {
        public Integer yearMade;
        
        public BasicTransport(Integer year) {
            this.yearMade = year;
        }
        
        public virtual String checkOil() {
            // TODO: Return "Oil level is normal"
            return 'Oil level is normal';
        }
        
        // TODO: Add virtual method scheduleService() that returns "Service scheduled in 30 days"
        public virtual String scheduleService() {
            return 'Service scheduled in 30 days';
        }
        
        // Method that shouldn't be overridden
        public void logUsage() {
            System.debug('Vehicle usage logged at ' + DateTime.now());
        }
    }

    public class Car extends VehicleDesign implements IVehicle {
        public Integer numDoors;
        
        public Car(String brand, String model, Integer doors) {
            // TODO: Call parent constructor with brand, model, and "Gasoline" as fuelType
            super(brand, model, 'Gasoline');
            this.numDoors = doors;
        }
        
        public String startEngine() {
            // TODO: Return "Car engine started with key"
            return 'Car engine started with key';
        }
        
        public Integer getMaxSpeed() {
            // TODO: Return 120 (mph)
            return 120;
        }
        
        public override String getMaintenance() {
            // TODO: Return maintenance info for cars
            return 'Car maintenance info: Check oil, check tires, check brakes';
        }
    }

    // TODO: Create Motorcycle class that extends VehicleDesign and implements IVehicle
    // - Constructor takes brand and model, calls parent with brand, model, and "Gasoline" as fuelType
    // - startEngine() returns "Motorcycle kicked to start"
    // - getMaxSpeed() returns 180
    // - getMaintenance() returns motorcycle-specific maintenance info

    public class Motorcycle extends VehicleDesign implements IVehicle{
        public Motorcycle(String brand, String model) {
            super(brand, model, 'Gasoline');
        }
        
        public String startEngine() {
            return 'Motorcycle kicked to start';
        }
        
        public Integer getMaxSpeed() {
            return 180;
        }    
        public override String getMaintenance() {
            return 'Motorcycle maintenance info: Check oil, check tires, check brakes';
        }
    }

    // TODO: Create Airplane class that extends BasicTransport and implements IVehicle
    // - Constructor takes model name and year, calls parent with year
    // - startEngine() returns "Broooooooom-poooooom"
    // - getMaxSpeed() returns 500
    // - Override checkOil() to return "Hydraulic fluid checked"

    public class Airplane extends BasicTransport implements IVehicle {
    private String model; // Declare the model variable

    public Airplane(String model, Integer year) {
        super(year);
        this.model = model;
    }
    
    public String startEngine() {
        return 'Broooooooom-poooooom';
    }
    
    public Integer getMaxSpeed() {
        return 500;
    }

    public override String checkOil() {
        return 'Hydraulic fluid checked';
    }
}

}