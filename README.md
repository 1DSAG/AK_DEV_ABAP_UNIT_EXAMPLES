# dsag_aunit
ABAP Unit Demo Code for DSAG
Based on the this talk [Experience Report regarding Unit Test by msg](https://www.dsag.de/dokumente/nothaft-msg-systems-abap-unit-msg-erfahrungsbericht) you can find here some of the examples.

# Demo for Integration of eCATT Testdata Container
- class zcl_demo_ecatt_aunit includes the demo code how to fetch data from an eCatt Container and verify it
- eCatt Testdata Container ZDEMO_ECATT_AUNIT contains the test data. In transaction SECATT you could also have a look at the tab "variants" to view the test data

# Instance Lookup
Just have a look at the class for reference zdsagcl_instance_lookup. This class enables a loose coupling within your application code.
The related classes/interfaces zdsagcl_business_func_multi1, zdsagcl_business_func_multi2, zdsagcl_business_func_single, zif_business_function_single and zif_business_function_multiple are just for demonstrating the functionality.

# OSQL / CDS Test Double
In class zcl_dac_stock you can find an example, how to apply the OSQL test double. For CDS please have a look at the where-used-list of class cl_cds_test_environment. But, it is really similiar to the handling of the OSQL test double class.

# Testdouble
Class zcl_td_bobf_frw_read demonstrates the usage of cl_abap_testdouble. Furthermore, you could also this class as a general test double for /bobf/if_frw_read.

# Generic BOPF Matcher
The class zdsagcl_td_bopf_matcher is not yet ready to use, because of the incomplete unit tests. But, with minor adoptions to your case, you could apply the matcher class.
The purpose of such a matcher class is especially required, if you have methods with referenced data. So, basically the class dereferences the parameters for comparison.
