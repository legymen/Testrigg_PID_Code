
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
        textSize(15);
        stroke(0,0,0);
        strokeWeight(1.0);
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

        if (mouseClicked && hovered)
        {
            clicked();
        }
    }

    void clicked()
    {   
        if (id == "p" || id == "i" || id == "d")
        {
            changepidconst(id);
        }
        delay(50);
    }

    void changepidconst(String id)
    {
        float val = grabvalue(id);
        if (val != -1)
        {        
            switch (id)
            {
                case "p":
                    kP = val;
                    break;
                case "i":
                    kI = val;
                    break;
                case "d":
                    kD = val;
                    break;
            }
            myPort.write(id+"\n"+val+"\n");
        }
    }

    float grabvalue(String id)
    {
        int i = findcorresponding(id);
        if (i == -1) {return -1;}
        float value = (inputfields.get(i)).getvalue();
        println(value);
        return value;
    }

    int findcorresponding(String id)
    {
        for (int i = 0; i < inputfields.size(); i++)
        {
            if ((inputfields.get(i)).id == id)
            {
                return i;
            }
        }
        return -1;
    }
}