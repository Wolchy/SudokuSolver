require("utils")
board = {}
chances = {}

function displayBoard()
	os.execute("cls")
	print("Sudoku Solver")
	print("=============")
	ttt = 0
	xxx = 0
	yyy = 0
	for n=1,tablelength(board) do
		if ttt == 9 then
			io.write("\n")
			ttt = 0
			yyy=yyy+1
			xxx = 0
		end
		if xxx == 3 then
			io.write(" ")
			xxx = 0
		end
		if yyy == 3 then
			print("")
			yyy = 0
		end
		io.write(tostring(board[n]))
		ttt=ttt+1
		xxx=xxx+1
	end
	print("")
end

function getBoard()
	clearTable(board)
	while tablelength(board) ~= 81 do
		displayBoard()
		
		num = io.read("*n")
		table.insert(board,num)
	end
end

function importStringToBoard(str)
	clearTable(board)
	for i = 1, #str do
		local c = str:sub(i,i)
		table.insert(board,tonumber(c))
	end
end

function getBoard2()
	importStringToBoard(io.read())
end

function getChancesX(x)
	x = x - 1
	xxx = (math.floor(x/9)*9)
	xxx = xxx + 1
	out = {}
	for n = xxx, xxx+8 do
		if board[n] ~= 0 then
			table.insert(out,board[n])
		end
	end
	return out
end
function getChancesY(x)
	xxx = x
	while xxx > 0 do xxx = xxx - 9 end
	xxx = xxx + 9
	xx = x
	while xx < 82 do xx = xx + 9 end
	xx = xx - 9
	out = {}
	for n = xxx, xx, 9 do
		if board[n] ~= 0 then
			table.insert(out,board[n])
		end
	end
	return out
end
function getChancesQuad(x)
	x=x-1
	xxxx = (math.floor(x/3)*3)
	xxxx = xxxx + 1
	ccc  = (math.floor((xxxx-1)/9)*9)
	ccc = ccc + 1
	dif = xxxx-ccc
	vv = xxxx/27
	vvv  = (math.floor((xxxx-1)/27)*27)
	vvv = vvv + 1
	xxx = vvv+dif
	
	out = {}
	for n=xxx,xxx+(9*2),9 do
		for nn=n,n+2 do
			if board[nn] ~= 0 then
				table.insert(out,board[nn])
			end
		end
	end
	return out
end
found = true
foundMessages = {}
function solveP1()
	clearTable(chances)
	for n,num in pairs(board) do
		if num == 0 then
			table.insert(chances,{1,2,3,4,5,6,7,8,9})
			
			for a,b in pairs(getChancesX(n)) do
				removeFromTable(chances[n], b)
			end
			for a,b in pairs(getChancesY(n)) do
				removeFromTable(chances[n], b)
			end
			for a,b in pairs(getChancesQuad(n)) do
				removeFromTable(chances[n], b)
			end
			
			if tablelength(chances[n]) == 1 then
				board[n] = getFirstItem(chances[n])
				chances[n] = {getFirstItem(chances[n])}
				table.insert(foundMessages, tostring(n)..": found one possability here setting it to: "..tostring(board[n]))
				found = true
			end
		else
			table.insert(chances,{num})
		end
	end
end

function solveP2()
	for x,num in pairs(board) do
		if num == 0 then
			x=x-1
			xxxx = (math.floor(x/3)*3)
			xxxx = xxxx + 1
			ccc  = (math.floor((xxxx-1)/9)*9)
			ccc = ccc + 1
			dif = xxxx-ccc
			vv = xxxx/27
			vvv  = (math.floor((xxxx-1)/27)*27)
			vvv = vvv + 1
			xxx = vvv+dif
			
			choices = {1,2,3,4,5,6,7,8,9}
			x=x+1
			for n=xxx,xxx+(9*2),9 do
				for nn=n,n+2 do
					if x ~= nn then
						for k,v in pairs(chances[nn]) do
							removeFromTable(choices,v)
						end
					end
				end
			end
			if tablelength(choices) == 1 then
				board[x] = getFirstItem(choices)
				chances[x] = {getFirstItem(choices)}
				table.insert(foundMessages, tostring(x)..": found one possability here setting it to: "..tostring(board[x]))
				found = true
			end
		end
	end
end

getBoard()
displayBoard()
while found do
	found = false
	solveP1()
	solveP2()
end
print("Found: "..tablelength(foundMessages))
for n,v in pairs(foundMessages) do
	--print(v)
end
os.execute("pause")
displayBoard()
os.execute("pause")