%Include typedef.sip

struct GUID
{
    %TypeHeaderCode
        #include <typedef.h>
        #include <kfc/guid.h>
    %End

    uint32 Data1;
    uint16 Data2;
    uint16 Data3;

    SIP_PYLIST Data4 /TypeHint="List[byte]"/
    {
        %GetCode
            sipPy = sipConvertToTypedArray((void *)sipCpp->Data4, 0, "bbbbbbbb", 8, 8, SIP_READ_ONLY);
        %End
        %SetCode
            for (int i = 0; i < 8; ++i)
            {
                PyObject *data = PyList_GetItem(sipPy, i);
                sipCpp->Data4[i] = sipLong_AsUnsignedChar(data);
            }
        %End
    };

    GUID(uint32 data1, uint16 data2, uint16 data3, SIP_PYLIST data4);
    %MethodCode
        sipCpp = new GUID();
        sipCpp->Data1 = a0;
        sipCpp->Data2 = a1;
        sipCpp->Data3 = a2;

        Py_ssize_t count = PyList_Size(a3);
        if (count > 8)
            count = 8;

        for (int i = 0; i < count; ++i)
        {
            PyObject *obj = PyList_GetItem(a3, i);
            sipCpp->Data4[i] = sipLong_AsUnsignedChar(obj);
        }

        for (int i = count; i < 8; ++i)
            sipCpp->Data4[i] = 0;
    %End

    GUID(SIP_PYOBJECT str);
    %MethodCode
        Py_ssize_t len = 0;
        const char *str = PyUnicode_AsUTF8AndSize(a0, &len);
        if (!str || len != 36)
            return SIP_NULLPTR;

        sipCpp = new GUID();
        sscanf(str, "%08x-%04hx-%04hx-%02hhx%02hhx-%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx",
            &sipCpp->Data1, &sipCpp->Data2, &sipCpp->Data3,
            &sipCpp->Data4[0], &sipCpp->Data4[1], &sipCpp->Data4[2],
            &sipCpp->Data4[3], &sipCpp->Data4[4], &sipCpp->Data4[5],
            &sipCpp->Data4[6], &sipCpp->Data4[7]);
    %End

    SIP_PYOBJECT __repr__() const /TypeHint="str"/;
    %MethodCode
        sipRes = PyUnicode_FromFormat("%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x",
            sipCpp->Data1, sipCpp->Data2, sipCpp->Data3,
            sipCpp->Data4[0], sipCpp->Data4[1],
            sipCpp->Data4[2], sipCpp->Data4[3], sipCpp->Data4[4],
            sipCpp->Data4[5], sipCpp->Data4[6], sipCpp->Data4[7]);
    %End
};

typedef GUID IID;
typedef GUID CLSID;
typedef const GUID& REFGUID;
typedef const IID& REFIID;
typedef const CLSID& REFCLSID;
