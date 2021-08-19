var Formatter = {
    format: function(value, showAMPM) {
        if(showAMPM) 
            return value;
      
        const values = value.split(' ');
        const vTime = values[0].split(':');
        const isPM = values[1] === 'PM';
        
        if (isPM) {
            vTime[0] = vTime[0] < 12 ? parseInt(vTime[0], 10) + 12 : '00';
        }
            
        return vTime.join(':');
    }
}
window["Formatter"] = Formatter;