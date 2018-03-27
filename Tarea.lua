require "dkl/DklRectNumAxis"
require "dkl/DklUtilities"

local datos
local valores
local maximo

function setup()
	size(1920,800)
	f = loadFont("data/Vera.ttf",14)
	textFont(f)
	colores = {"0xf8deb8","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e","0xc0d6e4","0xe8bad6","0x447f9c","0xc56b5e"}
	
	--waterfall chart
	--use el precio de bitcoin hasta 2017 fuente: https://www.buybitcoinworldwide.com/price/
	datos   = {"2009","2010","2011","2012","2013","2014","2015","2016","2017"}
	valores = {0,1,0.29,6.65,15.11,881.66,302,409.95,985.56}
	maximo = maxColumn(valores)
	
	--stackedBarGraph
	--Uso de redes sociales en 2018
	--http://www.pewinternet.org/2018/03/01/social-media-use-in-2018/
	--tomo la de usar ambas redes osea la interseccion de una con otra
	datosVerticales = {"Facebook","Youtube","Instagram","Pinterest","Snapchat"}
	valores2 = {{32,47,0,35,87,27,37,33},{31,45,81,35,0,28,36,32},{50,0,91,60,95,35,47,41},{41,56,89,41,92,25,0,42},{48,77,89,0,95,33,44,37}}
	valores3 ={"twitter","Instagram","Facebook","Snapchat","Youtube","Whatsapp","Pinterest","LinkedIn"}
end



function draw()
	background(255)
	waterfall(1000,50,maximo,50,2,valores,datos,colores,10)
	--bar(100,100,valores,colores,200,50)
	bars(100,100,100,1,datosVerticales,valores2,colores,500,valores3)
end

function bars(x,y,step,scale,values,data,colors,w,otherValues)
	total = 0
	maximum=maxWithDepth(data)
	for i, value in ipairs(values) do
		total=total+1
	end
	y0=y
	for j = 1, total do
		bar(x,y,data[j],colors,w*(sum(data[j])/maximum),50,otherValues)
		text(values[j],x-100,y+25)
		y=y+50+10
	end
	fill(0)
	stroke(0)
	line(x,y0,x,y)
	line(x,y,x+w,y)
	var=0
	y=y+20
	while(var<maximum) do 
		text(var,x+w*var/maximum,y)
		var=var+step
	end

end
function sum(list)
	total=0
	for i, value in ipairs(list) do
		total=total+value
	end
	return total
end

function bar(x,y,values,colors,width,height,otherValues)
	total=0
	size=1
	for i, value in ipairs(values) do
		total=total+value
		size=size+1
	end
	event(CLICKED)
	j=1
	for i, value in ipairs(values) do
		fill(colors[j])
		result=rect(x,y,width*(value/total),height)
		if(result)then
			fill(0)
			text(tostring(value) .. " " .. otherValues[j] ,result.mouseX,result.mouseY)
		end
		x=x+width*(value/total)
		j=j+1
	end
	

end

function maxWithDepth(list)
	max=0
	for i, value in ipairs(list) do
		m=0
		for j, n in ipairs(value) do
			m=m+n
		end
		if(m>max) then max=m end 
		
	end
	return max
end

function waterfall(x,y,maximum, step,scale,values,data,colors,space)
	total=0
	stroke(0)
	space=space*scale
	firstY=y;
	--numeros
	while(total<maximum) do
		line(x,y,x+space,y)
		text(maximum-total,x-space-30,y+5)
		total=total+step
		y=y+space
	end
	
	--nombres?
	j=2
	x1=x--la guardo para hacer la linea despues
	total=y-firstY
	y0=y
	y=y+space
	
	x=x+space*2
	doubleSpace=space*2
	value=0
	size=0
	for i, name in ipairs(data) do
		size=size+1
	end
	--colocacion de nombre y columna
	--primera
	fill(colors[1])
	text(data[1],x,y)
	event(CLICKED)
	result = rect(x, y0 - total*(values[1]/maximum),space,total*(values[1]/maximum))
	fill(0)
	if(result)then 
		text(values[1],result.mouseX,result.mouseY)
	end
	
	
	value = values[1]
	x=x+doubleSpace
	
	
	--siguientes
	for j = 2, size-1 do
		fill(colors[j])
		text(data[j],x,y)
		
		if(values[j-1]<values[j]) then
			result = rect(x, y0-total*(values[j]/maximum),space,total*(values[j]/maximum)-total*(values[j-1]/maximum))
		else
			result = rect(x, y0-total*(values[j-1]/maximum) ,space, total*((values[j-1]-values[j])/maximum)  )
		end
		
		fill(0)
		if(result)then 
			text(values[j],result.mouseX,result.mouseY)
		end
		x=x+doubleSpace
	end
	
	fill(colors[size])
	text(data[size],x,y)
	result= rect(x, y0 - total*(values[size]/maximum),space,total*(values[size]/maximum))
	
	if(result)then 
		fill(0)
		text(values[size],result.mouseX,result.mouseY)
	end
	
	value = values[size]
	
	fill(0)
	line(x1,y-space,x,y-space)
	
	
	
	
end