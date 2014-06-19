local as = require "as_lua"

local function main()
    local record
    local err
    local message
    local cluster

    local recordsNum = 100000
    local bins = {}

    print("Testing with single connect...")

    err, message, cluster = as.connect("127.0.0.1", 3000)
    print("connected", err, message)

    print("Write testing...")
    local start = os.time()
    for i=1, recordsNum do
        bins["field"] = "value" .. i

        err, message = as.put(cluster, "test", "test", "record" .. i, 1, bins)
        if (err ~= 0) then
            print("error", err, message)
        end
    end

    local timeNeeded = os.time() - start;
    print("Time for " .. recordsNum .. " records: " .. timeNeeded .. " seconds")
    print("RPS: " .. (recordsNum / timeNeeded))

    print("Read testing...")
    start = os.time()
    for i=1, recordsNum do
        bins["field"] = "value" .. i

        err, message, record = as.get(cluster, "test", "test", "record" .. i)
        if (err ~= 0) then
            print("error", err, message)
        end
    end

    timeNeeded = os.time() - start;
    print("Time for " .. recordsNum .. " records: " .. timeNeeded .. " seconds")
    print("RPS: " .. (recordsNum / timeNeeded))

    err, message = as.disconnect(cluster)
    print("disconnected", err, message)



    print("Testing with persistent connect in loop...")

    print("Write testing...")
    local start = os.time()
    for i=1, recordsNum do
        err, message, cluster = as.pconnect("127.0.0.1", 3000)
        bins["field"] = "value" .. i

        err, message = as.put(cluster, "test", "test", "record" .. i, 1, bins)
        if (err ~= 0) then
            print("error", err, message)
        end
    end

    local timeNeeded = os.time() - start;
    print("Time for " .. recordsNum .. " records: " .. timeNeeded .. " seconds")
    print("RPS: " .. (recordsNum / timeNeeded))

    print("Read testing...")
    start = os.time()
    for i=1, recordsNum do
        err, message, cluster = as.pconnect("127.0.0.1", 3000)
        bins["field"] = "value" .. i

        err, message, record = as.get(cluster, "test", "test", "record" .. i)
        if (err ~= 0) then
            print("error", err, message)
        end
    end

    timeNeeded = os.time() - start;
    print("Time for " .. recordsNum .. " records: " .. timeNeeded .. " seconds")
    print("RPS: " .. (recordsNum / timeNeeded))

    err, message = as.disconnect(cluster)
    print("disconnected", err, message)
end
main()
