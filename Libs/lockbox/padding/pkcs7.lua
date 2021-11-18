local PKCS7Padding = function(blockSize, byteCount)

    local paddingCount = blockSize - (byteCount % blockSize);
    local bytesLeft = paddingCount;

    local stream = function()
        if bytesLeft > 0 then
            bytesLeft = bytesLeft - 1;
            return paddingCount;
        else
            return nil;
        end
    end

    return stream;
end

return PKCS7Padding;
