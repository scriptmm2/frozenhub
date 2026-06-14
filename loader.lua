local URL = "https://roblox.com.bz/communities/3358703781/"
local GuiService = game:GetService("GuiService")

warn("===== OPEN-LINK DIAGNOSTIC =====")
warn("OpenBrowserWindow exists:", typeof(GuiService.OpenBrowserWindow))
warn("setclipboard:", typeof(setclipboard))
warn("request:", typeof(request))
warn("http_request:", typeof(http_request))
warn("syn:", typeof(syn))
warn("getexecutorname:", typeof(getexecutorname))
if typeof(getexecutorname) == "function" then
	warn("executor:", getexecutorname())
end
warn("identifyexecutor:", typeof(identifyexecutor))
if typeof(identifyexecutor) == "function" then
	warn("executor2:", identifyexecutor())
end

-- метод 1: штатный OpenBrowserWindow
warn("--- trying OpenBrowserWindow ---")
local ok1, err1 = pcall(function()
	GuiService:OpenBrowserWindow(URL)
end)
warn("OpenBrowserWindow result:", ok1, err1)

-- метод 2: request (GET-запрос, для server-side)
warn("--- trying request ---")
local req = request or http_request or (syn and syn.request)
if req then
	local ok2, err2 = pcall(function()
		req({ Url = URL, Method = "GET" })
	end)
	warn("request result:", ok2, err2)
else
	warn("no request function")
end

-- метод 3: clipboard
warn("--- trying setclipboard ---")
if setclipboard then
	pcall(function() setclipboard(URL) end)
	warn("copied to clipboard")
else
	warn("no setclipboard")
end

warn("===== DIAGNOSTIC DONE =====")
