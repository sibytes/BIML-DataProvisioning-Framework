using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Collections.Specialized;
using System.Reflection;
using System.Configuration;
using System.Globalization;
using System.Data;
using System.Data.OleDb;


namespace SemanticInsight.Weave
{
    public class BimlScript
    {
        public string ConnectionString { get; set; }

        public BimlScript()
        {
            ConnectionString = ReadConnectionString("SemanticWeaveConnection");
        }

        public BimlScript(string connectionString)
        {
            ConnectionString = connectionString;
        }

        #region GetTableDefinition
        public string GetTableDefinitionBiml(string rootComponentApplicationName, string connectionName, string databaseName, bool withSourceObject)
        {
            return GetTableDefinitionBiml(rootComponentApplicationName, connectionName, databaseName, null, null, null, withSourceObject);
        }

        public string GetTableDefinitionBiml(string rootComponentApplicationName, string connectionName, string databaseName, string schemaName, bool withSourceObject)
        {
            return GetTableDefinitionBiml(rootComponentApplicationName, connectionName, databaseName, schemaName, null, null, withSourceObject);
        }

        public string GetTableDefinitionBiml(string rootComponentApplicationName, string connectionName, string databaseName)
        {
            return GetTableDefinitionBiml(rootComponentApplicationName, connectionName, databaseName, null, null, null, false);
        }

        public string GetTableDefinitionBiml(string rootComponentApplicationName, string connectionName, string databaseName, string schemaName)
        {
            return GetTableDefinitionBiml(rootComponentApplicationName, connectionName, databaseName, schemaName, null, null, false);
        }

        private string GetTableDefinitionBiml(string rootComponentApplicationName, string connectionName, string databaseName, string schemaName, string sourceSchemaName, string sourceDatabaseName, bool withSourceObject)
        {
            SqlConnection con = new SqlConnection(this.ConnectionString);
            SqlCommand cmd = new SqlCommand();
            string returnValue;
            try
            {
                cmd.CommandText = "[semanticinsight].[get_table_definition_biml]";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Connection = con;

                cmd.Parameters.AddWithValue("@@root_component_application_name", rootComponentApplicationName);
                cmd.Parameters.AddWithValue("@@connection_name", connectionName);
                cmd.Parameters.AddWithValue("@@database_name", databaseName);
                if (schemaName != null)
                {
                    cmd.Parameters.AddWithValue("@@schema_name", schemaName);
                }
                if (sourceSchemaName != null)
                {
                    cmd.Parameters.AddWithValue("@@source_schema_name", sourceSchemaName);
                }
                if (sourceDatabaseName != null)
                {
                    cmd.Parameters.AddWithValue("@@source_database_name", sourceDatabaseName);
                }
                cmd.Parameters.AddWithValue("@@as_varchar", true);
                cmd.Parameters.AddWithValue("@@with_framework_attribute", !withSourceObject);
                cmd.Parameters.AddWithValue("@@with_source_object", withSourceObject);
                con.Open();

                returnValue = cmd.ExecuteScalar().ToString();

                con.Close();
            }
            catch (Exception ex)
            {
                throw new Exception("GetTableDefinitionBiml("
                    + "string rootComponentApplicationName=" + rootComponentApplicationName
                    + ", string connectionName=" + connectionName 
                    + ", string databaseName=" + databaseName 
                    + ", string schemaName =" + (schemaName == null ? "null" : schemaName)
                    + ", string schemaName =" + (sourceSchemaName == null ? "null" : sourceSchemaName)
                    + ", string schemaName =" + (sourceDatabaseName == null ? "null" : sourceDatabaseName)
                    + "): Error Occured ", 
                    ex.InnerException);
            }
            finally
            {
                con.Dispose();
                cmd.Dispose();
            }
            return returnValue;
        }
        #endregion GetTableDefinition

        #region GetColunmList
        public string GetColumnList(string rootComponentApplicationName, string schemaName, string dataObjectName, string bimlColumnList)
        {
            string ret = bimlColumnList;
            List<Tuple<string, string>> conversions = GetDefaultAttributesConversions(rootComponentApplicationName, schemaName, dataObjectName);
            foreach (var i in conversions)
            {
                string name = "[" + i.Item1 + "]";
                string conv = i.Item2;
                ret = ret.Replace(name, conv);
            }
            return ret;
        }
        #endregion GetColumnList

        private List<Tuple<string, string>> GetDefaultAttributesConversions(string rootComponentApplicationName, string schemaName, string dataObjectName)
        {
            SqlConnection con = new SqlConnection(this.ConnectionString);
            SqlCommand cmd = new SqlCommand();
            List<Tuple<string, string>> result = null;
            try
            {
                cmd.CommandText = "[semanticinsight].[get_default_attribute_conversions]";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Connection = con;

                cmd.Parameters.AddWithValue("@@root_component_application_name", rootComponentApplicationName);
                cmd.Parameters.AddWithValue("@@schema_name", schemaName);
                cmd.Parameters.AddWithValue("@@data_object_name", dataObjectName);

                result = new List<Tuple<string, string>>();
                using (con)
                {
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Tuple<string, string> r = new Tuple<string, string>(Convert.ToString(reader["data_attribute_name"]), Convert.ToString(reader["data_attribute_conversion"]));
                            result.Add(r);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("GetDefaultAttributesConversions("
                    + "string rootComponentApplicationName=" + rootComponentApplicationName
                    + ", string schemaName=" + schemaName
                    + ", string dataObjectName=" + dataObjectName
                    + "): Error Occured ",
                    ex.InnerException);
            }
            finally
            {
                con.Dispose();
                cmd.Dispose();
            }
            return result;
        }

        private bool HasDefaultAttributeConversion(string rootComponentApplicationName, string schemaName, string dataObjectName)
        {
            SqlConnection con = new SqlConnection(this.ConnectionString);
            SqlCommand cmd = new SqlCommand();
            bool returnValue;
            try
            {
                cmd.CommandText = "[semanticinsight].[has_default_attribute_conversion]";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Connection = con;

                cmd.Parameters.AddWithValue("@@root_component_application_name", rootComponentApplicationName);
                cmd.Parameters.AddWithValue("@@schema_name", schemaName);
                cmd.Parameters.AddWithValue("@@data_object_name", dataObjectName);

                con.Open();

                returnValue = (bool)cmd.ExecuteScalar();

                con.Close();
            }
            catch (Exception ex)
            {
                throw new Exception("HasDefaultAttributeConversion("
                    + "string rootComponentApplicationName=" + rootComponentApplicationName
                    + ", string schemaName=" + schemaName
                    + ", string dataObjectName=" + dataObjectName
                    + "): Error Occured ",
                    ex.InnerException);
            }
            finally
            {
                con.Dispose();
                cmd.Dispose();
            }
            return returnValue;
        }



        public void MapDataAttributes(
            string rootComponentApplicationName, 
            string sourceComponentApplicationName, 
            string destinationComponentApplicationName, 
            string sourceDataSchemaName, 
            string destinationDataSchemaName, 
            string sourceDataObjectName, 
            string destinationDataObjectName,
            bool mapAttributesOnName)
        {
            SqlConnection con = new SqlConnection(this.ConnectionString);
            SqlCommand cmd = new SqlCommand();

            try
            {
                cmd.CommandText = "[semanticinsight].[map_data_attributes]";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Connection = con;

                cmd.Parameters.AddWithValue("@@root_component_application_name", rootComponentApplicationName);
                cmd.Parameters.AddWithValue("@@source_component_application_name", sourceComponentApplicationName);
                cmd.Parameters.AddWithValue("@@destination_component_application_name", destinationComponentApplicationName);
                cmd.Parameters.AddWithValue("@@source_data_schema_name", sourceDataSchemaName);
                cmd.Parameters.AddWithValue("@@destination_data_schema_name", destinationDataSchemaName);
                cmd.Parameters.AddWithValue("@@source_data_object_name", sourceDataObjectName);
                cmd.Parameters.AddWithValue("@@destination_data_object_name", destinationDataObjectName);
                cmd.Parameters.AddWithValue("@@map_attributes_on_name", mapAttributesOnName);
                cmd.Parameters.AddWithValue("@@return_id", false);

                con.Open();

                cmd.ExecuteNonQuery();

                con.Close();
            }
            catch (Exception ex)
            {
                throw new Exception("MapDataAttributes("
                    + "string rootComponentApplicationName=" + rootComponentApplicationName
                    + ", string sourceComponentApplicationName=" + sourceComponentApplicationName
                    + ", string destinationComponentApplicationName=" + destinationComponentApplicationName
                    + ", string sourceDataSchemaName=" + sourceDataSchemaName
                    + ", string destinationDataSchemaName=" + destinationDataSchemaName
                    + ", string sourceDataObjectName=" + sourceDataObjectName
                    + ", string destinationDataObjectName=" + destinationDataObjectName
                    + ", bool mapAttributesOnName=" + mapAttributesOnName.ToString()
                    + "): Error Occured ",
                    ex.InnerException);
            }
            finally
            {
                con.Dispose();
                cmd.Dispose();
            }
        }


        private string ReadConnectionString(string key)
        {
            //Open the configuration file using the dll location
            string l = this.GetType().Assembly.Location;
            System.Configuration.Configuration myDllConfig = ConfigurationManager.OpenExeConfiguration(l);
            AppSettingsSection myDllConfigAppSettings = (AppSettingsSection)myDllConfig.GetSection("appSettings");
            // return the desired field 
            return myDllConfigAppSettings.Settings[key].Value; 

        }
    }
}
