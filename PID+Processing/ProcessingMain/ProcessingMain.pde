import processing.serial.*;

// Arduino variables.
Serial myPort;
String indata; // Value from Serial port.
String datastr;
String timestr;
int data;
float time;

ArrayList<Graph> graphs;
PVector epoint;
PFont textfont;

public void settings() 
{
    //fullScreen(); // Should OpenGL be used as renderer?
    size(1800,1000);
}

void setup()
{
    background(60, 60, 60);
    textAlign(CENTER, CENTER);
    stroke(255, 255, 255);
    textfont = createFont("CascadiaCode.ttf", 18);
    textFont(textfont);

    while (arduinoinit(921600) != 0) {delay(2000);};

    graphs = new ArrayList<Graph>();
    graphs.add(new Graph(width/8, height/4, "Error", "e [deg]", "time [s]"));
}

void draw()
{
    getserialinput();
    background(60, 60, 60);

    // Plot all shown graphs.
    for (int i = 0; i < graphs.size(); i++)
    {
        Graph current = graphs.get(i);
        println(time);
        epoint = new PVector(time, data);
        current.updatevalues(epoint);
        if (current.show); current.plot();
    }

}

int arduinoinit(int baudRate) {
    try 
    {
        myPort = new Serial(this, Serial.list()[0], baudRate);
    }
    catch (Exception RuntimeException)
    {
        println("Port not found. Is the Arduino connected to the correct port?");
        return 1;
    }

    println("Arduino found. Baud Rate: " + baudRate, "Please wait.");
    // TODO: Send clear-signal to Arduino.
    delay(2000);
    myPort.clear();
    return 0;
}

// TODO: Since only numbers are being sent through the Serial from the Arduino, maybe sending bytes would be faster?
void getserialinput()
{
    // If data is available.
    if (myPort.available() > 0) 
    {  
        indata = myPort.readStringUntil('\n');
        datastr = readbetween(indata,'d','t');
        timestr = readbetween(indata, 't', '\n');
        try 
        {
        data = Integer.valueOf(datastr.trim());
        time = Float.valueOf(timestr.trim());
        }
        catch (Exception e)
        {
            ;
        }
    }
}

String readbetween(String s, char f, char t)
{
    if (s != "" && s != null)
    {
        int fi = s.indexOf(f);
        int ti = s.indexOf(t);
        if (fi >= 0 && ti > 0)
        {
            return s.substring(fi + 1, ti);
        }
        else 
        {
            return "";
        }
    }
    else
    {
        return "";
    }
}