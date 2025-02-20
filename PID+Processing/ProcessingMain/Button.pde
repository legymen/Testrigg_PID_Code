
class Button {
    float xpos, ypos, butwidth, butheight, butradius;
    String label, id;
    boolean show = true;
    boolean hovered = false;
    Button(float _xpos, float _ypos, float _width, float _height, float _r, String _label, String _id)
    {
        xpos = _xpos;
        ypos = _ypos;
        label = _label;
        butwidth = _width;
        butheight = _height;
        butradius = _r;
        id = _id;
    }

    void update()
    {   
        if (mouseX > (xpos - butwidth/2) && mouseX < (xpos + butwidth/2) && mouseY > (ypos - butheight/2) && (mouseY < ypos + butheight/2))
        {
            fill(220, 220, 220);
            hovered = true;
        }
        else 
        {
            fill(255,255,255);
            hovered = false;
        }
        rect(xpos, ypos, butwidth, butheight, butradius);
        fill(0,0,0);
        text(label, xpos, ypos);
    }

    void clicked()
    {
        myPort.write("i\n1\n");
        delay(500);
    }
}