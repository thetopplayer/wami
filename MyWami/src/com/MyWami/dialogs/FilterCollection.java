package com.MyWami.dialogs;

    import android.app.Dialog;
    import android.content.Context;
    import android.content.Intent;
    import android.graphics.Color;
    import android.view.View;
    import android.view.Window;
    import android.widget.*;
    import com.MyWami.R;
    import com.MyWami.WamiListActivity;
    import com.MyWami.model.GroupModel;
    import com.MyWami.util.Constants;
    import com.MyWami.webservice.JsonGetData;
    import org.json.JSONArray;
    import org.json.JSONException;
    import org.json.JSONObject;


/**
 * Created by robertlanter on 5/18/14.
 */
public class FilterCollection {
  private GroupModel[] groupModel;
  private Context context;
  final private String GET_PROFILE_GROUP_DATA = Constants.IP + "get_profile_group_data.php";
  private String groupNameSelected;
  private int profileGroupIdSelected;

  public FilterCollection() {

  }

  public void filterCollection(final Context context, final String userIdentityProfileId) {
    this.context = context;

    final Dialog dialog = new Dialog(context);
    dialog.getWindow();
    dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
    dialog.setContentView(R.layout.dialog_filter_collection_by_group);

    String[] postData = { userIdentityProfileId };
    JsonGetData jsonGetData = new JsonGetData();
    jsonGetData.jsonGetData(context, GET_PROFILE_GROUP_DATA, postData);
    String jsonResult = jsonGetData.getJsonResult();
    JSONObject jsonResponse = null;
    try {
      jsonResponse = new JSONObject(jsonResult);
      int ret_code = jsonResponse.optInt("ret_code");
      if (ret_code == 1) {
        Toast.makeText(context, "No Groups have been created yet!", Toast.LENGTH_LONG).show();
        return;
      }
    }
    catch (JSONException e) {
      e.printStackTrace();
    }

    groupModel = assignData(jsonResult);

    final Spinner dropdown = (Spinner)dialog.findViewById(R.id.select_group_edit);
    int numElements = groupModel.length;
    String[] groupNames = new String[numElements + 1];
    groupNames[0] = "All Groups";
    for (int i = 1; i <= numElements; i++) {
      groupNames[i] = groupModel[i - 1].getGroupName();
    }
    ArrayAdapter<String> adapter = new ArrayAdapter<String>(context, android.R.layout.simple_spinner_dropdown_item, groupNames);
    dropdown.setAdapter(adapter);

    dropdown.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
        ((TextView) parentView.getChildAt(0)).setTextColor(Color.BLACK);
        groupNameSelected = String.valueOf(((TextView) parentView.getChildAt(0)).getText());
      }

      @Override
      public void onNothingSelected(AdapterView<?> parent) {

      }
    });

    Button closeFilter = (Button) dialog.findViewById(R.id.close_filter);
    closeFilter.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        dialog.dismiss();
      }
    });

    Button filterCollection = (Button) dialog.findViewById(R.id.filter_collection);
    filterCollection.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        Intent intent = new Intent(context, WamiListActivity.class);
        intent.putExtra("user_identity_profile_id", userIdentityProfileId);
        intent.putExtra("use_default", false);
        intent.putExtra("group_name_selected", groupNameSelected);
        if (groupNameSelected.equals("All Groups")) {
          profileGroupIdSelected = -99;
        }
        else {
          int num_groups = groupModel.length;
          for (int i = 0; i < num_groups; i++) {
            String groupName = groupModel[i].getGroupName();
            if (groupName.equals(groupNameSelected)) {
              profileGroupIdSelected = groupModel[i].getProfileGroupId();
              break;
            }
          }
        }
        intent.putExtra("profile_group_id", profileGroupIdSelected);
        context.startActivity(intent);
        dialog.dismiss();
      }
    });

    dialog.show();
  }

  private GroupModel[] assignData(String jsonResult) {
    try {
      JSONObject jsonResponse = new JSONObject(jsonResult);
      JSONArray jsonMainNode = jsonResponse.optJSONArray("profile_group_data");

      groupModel = new GroupModel[jsonMainNode.length()];
      for (int i = 0; i < jsonMainNode.length(); i++) {
        JSONObject jsonChildNode = jsonMainNode.getJSONObject(i);
        int identityProfileId = jsonChildNode.optInt("identity_profile_id");
        String groupName = jsonChildNode.optString("group");
        int profileGroupId = jsonChildNode.optInt("profile_group_id");

        groupModel[i] = new GroupModel();
        groupModel[i].setIdentityProfileId(identityProfileId);
        groupModel[i].setGroupName(groupName);
        groupModel[i].setProfileGroupId(profileGroupId);
      }
    }
    catch (JSONException e) {
      e.printStackTrace();
      Toast.makeText(context, "Error" + e.toString(), Toast.LENGTH_LONG).show();
    }

    return groupModel;
  }
}
