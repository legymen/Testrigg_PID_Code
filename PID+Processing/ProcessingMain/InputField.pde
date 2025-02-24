
/* TODO:
    Generalize the submit() class a bit.
*/

class InputField {
    float xpos, ypos, w, h;
    String id;
    boolean activated = false, clicked = false, includeslider;
    ArrayList<Character> input;
    String inputstr;
    Button correspondingbutton;
    color c;
    int tsize = 20;
    Slider slider;

    InputField(float _xpos, float _ypos, float _w, float _h, String _id, boolean _includeslider)
    {
        xpos = _xpos;
        ypos = _ypos;
        w = _w;
        h = _h;
        id = _id;
        input = new ArrayList<Character>();
        includeslider = _includeslider;

        // Create input button.
        buttons.add(new Button(xpos + w/2 + width/42, ypos, width/25.7, height/33.3, 5.0, "Submit", id));
        correspondingbutton = buttons.get(buttons.size() - 1);

        if (includeslider)
        {
            sliders.add(new Slider(xpos + w/2 + width/20, ypos, 0, 40, id));
            slider = sliders.get(sliders.size() - 1);
        }
    }

    void update()
    {
        // Check if mouse is clicked.
        if (mouseClicked && mouseX > (xpos - w/2) * scaleX && mouseX < (xpos + w/2) * scaleX && mouseY < (ypos + h/2) * scaleY && mouseY > (ypos - h/2) * scaleY)
        {
            clicked = true;
        }
        else if (mouseClicked)
        {
            clicked = false;
        }

        // Draw inputfield.
        noFill();
        c = clicked ? color(255,255,255) : color(200, 200, 200);
        stroke(c);
        strokeWeight(1.4);
        rect(xpos, ypos, w, h);

        // Check for user input
        if ((clicked && keyClicked && key == ENTER && key != CODED && input.size() > 0) || correspondingbutton.clicked)
        {
            submit();
        }
        else if (clicked && keyClicked && key == BACKSPACE && key != CODED && input.size() > 0)
        {
            input.remove(input.size() - 1);
        }
        else if (clicked && keyClicked && key != BACKSPACE && key != CODED && input.size() < 6)
        {
            if (Character.isDigit(key))
            {
                input.add(key);
            }
            else if (key == '.' || key == ',')
            {
                if (key == ',') key = '.';
                input.add(key);
            }
        }

        if (includeslider && !slider.dragging) 
        {
            slider.val = input.size() == 0 ? 0 : float(inputstr);
        } 
        else if (includeslider)
        {
            input.clear();
            String sliderstr = str(round(100*slider.val)/100.0);
            for (int i = 0; i < sliderstr.length(); i++)
            {
                input.add(sliderstr.charAt(i));
            }
        }

        // If anything has been added to the inputfield, write it out.
        if (input.size() > 0)
        {
            inputstr = "";
            for (int i = 0; i < input.size(); i++)
            {
                inputstr += input.get(i);
            }
            textSize(tsize);
            fill(255, 255, 255);
            textAlign(LEFT, CENTER);
            text(inputstr, xpos - w/2.20, ypos);
            textAlign(CENTER, CENTER);
        }

        // Draw flashing line
        if (clicked && (frameCount % 30) <= 10)
        {   
            float offset = (input.size() == 0) ? 0 : textWidth(inputstr);
            line((xpos - w/2.20) + offset, ypos - h/3.5, (xpos - w/2.20) + offset, ypos + h/3.5);
        }
    }

    float getvalue()
    {   
        float val;
        try
        {
            val = float(inputstr);
        }
        catch (Exception e)
        {
            val = -1;
        }

        input.clear();
        return val;
    }

    // TODO: Generalize this a bit, to allow for inputfields that do other things than changing pid constants.
    void submit()
    {
        float val = getvalue();
        changepidconst(id, val);
    }
}