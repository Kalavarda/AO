local registeredHaders = {}

function RegisterEvent(func, headerName)
  if registeredHaders[headerName] == nil then
    registeredHaders[headerName] = {}
  end
  if not registeredHaders[headerName][func] then
    common.RegisterEventHandler(func, headerName)
    registeredHaders[headerName][func] = true
  end
end

function UnRegisterEvent(func, headerName)
  if not registeredHaders[headerName] == nil
    and registeredHaders[headerName][func] then
    common.UnRegisterEventHandler(func, headerName)
  end
end