package com.MyWami;

import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.TextView;
import com.MyWami.model.GroupModel;
import com.MyWami.model.ProfileModel;

/**
 * Created by robertlanter on 3/10/14.
 */
public class FilterCollectionAdapter extends ArrayAdapter<GroupModel> {
  private final Context context;
  private GroupModel[] groupModel;

  public FilterCollectionAdapter(Context context, int layoutResourceId, GroupModel[] groupModel) {
    super(context, layoutResourceId, groupModel);
    this.context = context;
    this.groupModel = groupModel;
  }

  public View getView(final int position, View convertView, ViewGroup parent) {
    LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    View rowView = inflater.inflate(R.layout.select_profile, parent, false);

    TextView profileName = (TextView) rowView.findViewById(R.id.profile_name_text);
//    profileName.setText(groupModel[position].getProfileName());

    return rowView;
  }

  private void clearChecked(int position) {
//    for (int i = 0; i < profileModel.length; i++) {
//      if (i == position) continue;
//      profileModel[i].setSelected(false);
//      checkBoxState[i] = false;
//      notifyDataSetChanged();
//    }
  }

}
