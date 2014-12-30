package com.MyWami.dialogs;

    import android.app.Dialog;
    import android.content.Context;
    import android.content.Intent;
    import android.graphics.Color;
    import android.view.View;
    import android.view.Window;
    import android.widget.*;
    import com.MyWami.FilterCollectionAdapter;
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
  String userIdentityProfileId;

  public FilterCollection() {

  }

  public void filterCollection(final Context context, String userIdentityProfileId) {
    this.context = context;
    this.userIdentityProfileId = userIdentityProfileId;

    final Dialog dialog = new Dialog(context);
    dialog.getWindow();
    dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
    dialog.setContentView(R.layout.dialog_filter_collection_by_group);

    String[] postData = { userIdentityProfileId };
    JsonGetData jsonGetData = new JsonGetData();
    jsonGetData.jsonGetData(context, GET_PROFILE_GROUP_DATA, postData);
    String jsonResult = jsonGetData.getJsonResult();
    groupModel = assignData(jsonResult);
    setSelected(userIdentityProfileId);

    final Spinner dropdown = (Spinner)dialog.findViewById(R.id.select_group_edit);
    String[] items = new String[]{"Profile Name", "First Name", "Last Name", "Tags", "Description"};
    ArrayAdapter<String> adapter = new ArrayAdapter<String>(context, android.R.layout.simple_spinner_dropdown_item, items);
    dropdown.setAdapter(adapter);

    dropdown.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
        ((TextView) parentView.getChildAt(0)).setTextColor(Color.BLACK);
      }

      @Override
      public void onNothingSelected(AdapterView<?> parent) {

      }
    });

//    ListView listView = (ListView) dialog.findViewById(R.id.profile_collection_list);
//    FilterCollectionAdapter spa = new FilterCollectionAdapter(context, R.layout.dialog_filter_collection_by_group, groupModel);
//    listView.setAdapter(spa);

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
        boolean isSelected = false;
        for (GroupModel aGroupModel : groupModel)
          if (aGroupModel.isSelected()) {
            isSelected = true;
            String identityProfileId = String.valueOf(aGroupModel.getIdentityProfileId());
            Intent i = new Intent(context, WamiListActivity.class);
            i.putExtra("user_identity_profile_id", identityProfileId);
            i.putExtra("use_default", false);
            context.startActivity(i);
            dialog.dismiss();
          }
        if (!isSelected) {
          Toast.makeText(context, "Please select a group from dropdown list or hit the Close button.", Toast.LENGTH_LONG).show();
        }
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

  private void setSelected(String userIdentityProfileId) {
    for (int i = 0; i < groupModel.length; i++) {
      if (groupModel[i].getIdentityProfileId() == Integer.parseInt(userIdentityProfileId)) {
        groupModel[i].setSelected(true);
        return;
      }
    }
  }
}
