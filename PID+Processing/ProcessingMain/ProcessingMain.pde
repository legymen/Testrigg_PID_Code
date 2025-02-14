import processing.serial.*;

// Arduino variables.
Serial myPort;
static String val; // Value from Serial port.

ArrayList<Graph> graphs;

public void settings() 
{
    fullScreen(OPENGL);
}

void setup()
{
    background(60, 60, 60);
    textAlign(CENTER, CENTER);
    stroke(255, 255, 255);
    //arduinoinit(961600);

    graphs = new ArrayList<Graph>();
    graphs.add(new Graph(width/8, height/4, "Error", "e [deg]", "time [s]"));
}

void draw()
{
    //getserialinput();
    background(60, 60, 60);

    // Plot all shown graphs.
    for (int i = 0; i < graphs.size(); i++)
    {
        Graph current = graphs.get(i);
        if (current.show); current.plot();
    }
}

void arduinoinit(int baudRate) {
    String portName = "COM5"; // Change the number (in this case) to match the corresponding port number connected to your Arduino.    

    try 
    {
        myPort = new Serial(this, portName, baudRate);
    }
    catch (Exception RuntimeException)
    {
        println("Port " + portName + " not found. Is the Arduino connected to the correct port?");
        exit();
    }

    println("Arduino found on port " + portName, ". Baud Rate: " + baudRate);
}

void getserialinput()
{
    // If data is available.
    if (myPort.available() > 0) 
    {  
        val = myPort.readStringUntil('\n');
    }
}