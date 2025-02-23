
class Button {
    float xpos, ypos, butwidth, butheight, butradius;
    String label, id;
    boolean hovered = false, clicked = false, show = true;
    color c;
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
        textSize(15);
        stroke(0,0,0);
        strokeWeight(0.5);
        if (mouseX > (xpos - butwidth/2) * scaleX && mouseX < (xpos + butwidth/2) * scaleX && mouseY > (ypos - butheight/2) * scaleY && mouseY < (ypos + butheight/2) * scaleY)
        {
            c = color(200, 200, 200);
            hovered = true;
        }
        else 
        {
            c = color(255, 255, 255);
            hovered = false;
        }
        fill(c);
        rect(xpos, ypos, butwidth, butheight, butradius);
        fill(0,0,0);
        text(label, xpos, ypos);

        if (mouseClicked && hovered)
        {
            clicked();
        }
        else
        {
            clicked = false;
        }
    }

    // This is a function just to leave the ability to do more here in the future.
    void clicked()
    {   
        clicked = true;
    }
}